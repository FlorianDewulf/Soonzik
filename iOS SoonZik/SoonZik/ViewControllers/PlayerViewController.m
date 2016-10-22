//
//  PlayerViewController.m
//  SoonZik
//
//  Created by LLC on 13/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "PlayerViewController.h"
#import "AppDelegate.h"
#import "Tools.h"
#import "SVGKImage.h"
#import "CurrentListViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
   
    self.player = [AudioPlayer sharedCenter];
    self.player.finishDelegate = self;
    
    self.scrollView.userInteractionEnabled = false;
    
    if (self.player.listeningList.count == 0)
    {
        [self.player prepareSong:0];
        [self.navigationController popViewControllerAnimated:false];
    } else {
        self.view.backgroundColor = DARK_GREY;
        
        self.navigationItem.hidesBackButton = YES;
        UIImage *closeImage = [Tools imageWithImage:[SVGKImage imageNamed:@"close"].UIImage scaledToSize:CGSizeMake(30, 30)];
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(closePlayerViewController)];
        [closeButton setTintColor:[UIColor whiteColor]];
        self.navigationItem.leftBarButtonItem = closeButton;
        
        UIImage *currentListenImage = [Tools imageWithImage:[SVGKImage imageNamed:@"current_listen"].UIImage scaledToSize:CGSizeMake(30, 30)];
        UIBarButtonItem *listenButton = [[UIBarButtonItem alloc] initWithImage:currentListenImage style:UIBarButtonItemStylePlain target:self action:@selector(displayCurrentListen)];
        [listenButton setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = listenButton;
        
        [self.progressionSlider setThumbImage:[Tools imageWithImage:[SVGKImage imageNamed:@"dot"].UIImage scaledToSize:CGSizeMake(14, 14)] forState:UIControlStateNormal];
        [self.shareButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"share_white"].UIImage scaledToSize:CGSizeMake(24, 24)] forState:UIControlStateNormal];
        
        self.navigationItem.hidesBackButton = NO;
        self.navigationItem.backBarButtonItem.title = @"";
        
        [self refresh];
        [self initPlayer];
        
        self.songTitle.font = SOONZIK_FONT_BODY_BIG;
        self.songArtist.font = SOONZIK_FONT_BODY_MEDIUM;
        
        self.currentTimeLabel.font = SOONZIK_FONT_BODY_VERY_SMALL;
        self.finishTimeLabel.font = SOONZIK_FONT_BODY_VERY_SMALL;
        
        [self.previousButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"icon_previous"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
        [self.nextButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"icon_next"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
        [self.playButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"icon_play-circle"].UIImage scaledToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        
        [self.progressionSlider setMinimumTrackTintColor:BLUE_1];
    }
    
}

- (void)displayCurrentListen {
    self.currentListViewController = [[CurrentListViewController alloc] initWithNibName:@"CurrentListViewController" bundle:nil];
    [self.navigationController pushViewController:self.currentListViewController animated:YES];
}

- (void) initPlayer
{
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.clipsToBounds = NO;
    
    CGFloat contentOffset = 0.0f;
    
    for (int i = 0; i < self.player.listeningList.count; i++) {
        contentOffset += self.scrollView.frame.size.width;
    }
    self.scrollView.contentSize = CGSizeMake(contentOffset, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake((contentOffset / self.player.listeningList.count) * self.player.index, 0);
    
    [self loadPictureAtIndexOfPage:self.player.index];
}

- (void)loadPictureAtIndexOfPage:(int)page {
    float imageWith = self.view.frame.size.width;
    float imageEcart = 0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activity.frame = CGRectMake(page * imageWith + imageEcart * (page * 2 + 1), self.scrollView.frame.origin.y, imageWith, imageWith);
        [self.scrollView addSubview:activity];
        [activity startAnimating];

        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(page * imageWith + imageEcart * (page * 2 + 1), self.scrollView.frame.origin.y, imageWith, imageWith)];
        Music *music = [self.player.listeningList objectAtIndex:page];
        NSString *urlImage = [NSString stringWithFormat:@"%@assets/albums/%@", API_URL, music.albumImage];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
        
        [self.scrollView addSubview:imgV];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            imgV.image = [UIImage imageWithData:imageData];
            NSLog(@"image loaded");
            [activity stopAnimating];
            [activity removeFromSuperview];
        });
    });
}

/*- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    [self.player stopSound];
    
    self.player.index = self.indexOfPage;
    Music *music = [self.player.listeningList objectAtIndex:self.indexOfPage];
    [self.player prepareSong:music.identifier];

    [self.player playSound];
}*/

- (void)closePlayerViewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)refresh
{
    Music *s = [self.player.listeningList objectAtIndex:self.player.index];

    if (self.player.listeningList.count > 0) {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refreshDisplay) userInfo:nil repeats:YES];
        
        [self.progressionSlider setMinimumValue:0.0];
        [self.progressionSlider setMaximumValue:s.duration];
    } else {
        [self.progressionSlider setValue:0.0];
        [self.progressionSlider setMaximumValue:s.duration];
        int duration = 0;
        self.finishTimeLabel.text = [NSString stringWithFormat:@"%.02d:%.02d", duration/60, duration%60];
        
        int current = 0;
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%.02d:%.02d", current/60, current%60];
    }
}

- (void)refreshDisplay
{
    if (self.player.listeningList.count > 0) {
        if (!self.player.currentlyPlaying) {
            [self.playButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"icon_play-circle"].UIImage scaledToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        } else {
            [self.playButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"icon_pause-circle"].UIImage scaledToSize:CGSizeMake(40, 40)] forState:UIControlStateNormal];
        }
        
        Music *s = [self.player.listeningList objectAtIndex:self.player.index];
        
        [self.progressionSlider setMaximumValue:s.duration];
        
        int duration = s.duration;
        self.finishTimeLabel.text = [NSString stringWithFormat:@"%.02d:%.02d", duration/60, duration%60];
        
        int current = CMTimeGetSeconds(self.player.audioPlayer.currentItem.currentTime);
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%.02d:%.02d", current/60, current%60];
        
        [self.progressionSlider setValue:current];
        
        self.songTitle.text = s.title;
        self.songArtist.text = s.artist.username;
    }
}

- (IBAction)goToThisPeriod:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    
    if (slider.value >= 30) {
        [self.player pauseSound];
    } else {
       [self.player playSoundAtPeriod:slider.value]; 
    }
  
}

- (IBAction)play:(id)sender
{
    if (self.player.currentlyPlaying) {
        [self.player pauseSound];
    } else {
        [self.player playSound];
    }
}

- (IBAction)previous:(id)sender
{
    [self.player previous];
    [self.scrollView setContentOffset:CGPointMake(self.player.index*self.scrollView.frame.size.width, 0) animated:YES];
    
    [self loadPictureAtIndexOfPage:self.player.index];
}

- (IBAction)next:(id)sender
{
    [self.player next];
    [self.scrollView setContentOffset:CGPointMake(self.player.index*self.scrollView.frame.size.width, 0) animated:YES];
    
    [self loadPictureAtIndexOfPage:self.player.index];
}

- (void)playerHasFinishedToPlay
{
    NSLog(@"player has finished to play");
    //[self.player next];
    [self.scrollView setContentOffset:CGPointMake(self.player.index*self.scrollView.frame.size.width, 0) animated:YES];
    
    [self loadPictureAtIndexOfPage:self.player.index];
}

- (void)refreshDisp {
    NSLog(@"player display");
    [self.scrollView setContentOffset:CGPointMake(self.player.index*self.scrollView.frame.size.width, 0) animated:YES];
    
    [self loadPictureAtIndexOfPage:self.player.index];
}

@end
