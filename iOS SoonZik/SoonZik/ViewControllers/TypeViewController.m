//
//  TypeViewController.m
//  SoonZik
//
//  Created by devmac on 27/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"
#import "HomeViewController.h"
#import "PlayerViewController.h"
#import "BattleViewController.h"
#import "ContentViewController.h"
#import "GeolocationViewController.h"
#import "PackViewController.h"
#import "ArtistViewController.h"
#import "ExploreViewController.h"
#import "FriendsViewController.h"
#import "MusicOptionsButton.h"
#import "AppDelegate.h"
#import "Music.h"
#import "Tools.h"
#import "SVGKImage.h"
#import "AlbumViewController.h"
#import "SimplePopUp.h"
#import "ShareActionSheet.h"
#import "MessagePopUp.h"

@interface TypeViewController ()

@end

@implementation TypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *menuImage = [Tools imageWithImage:[SVGKImage imageNamed:@"menu"].UIImage scaledToSize:CGSizeMake(30, 30)];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController)];
    menuButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    UIImage *searchImage = [Tools imageWithImage:[SVGKImage imageNamed:@"search"].UIImage scaledToSize:CGSizeMake(30, 30)];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController)];
    searchButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    [self initTitleView];
    
    self.view.backgroundColor = DARK_GREY;
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;

    //self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    self.player = [AudioPlayer sharedCenter];
    self.player.finishDelegate = self;
    
    [self refreshThePlayerPreview];
    
    [Socket sharedCenter].delegate = self;
    
}

- (void)messageHasBeenReceived:(Message *)msg {
    NSLog(@"message.content: %@", msg.content);
    NSLog(@"message.fromUsername: %@", msg.fromUsername);
    MessagePopUp *popUp = (MessagePopUp *)[[[NSBundle mainBundle] loadNibNamed:@"MessagePopUp" owner:self options:nil] firstObject];
    [self.view addSubview:popUp];
    popUp.usernameLabel.text = msg.fromUsername;
    popUp.contentLabel.text = msg.content;
    [popUp initView];
}

- (void)presentLeftMenuViewController {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.revealController showLeftViewController];
}

- (void)presentRightMenuViewController {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.revealController showRightViewController];
}

- (void)playerHasFinishedToPlay
{
    NSLog(@"fini");
}

- (void)initTitleView
{
    TitleSongPreview *songPreview = [[[NSBundle mainBundle] loadNibNamed:@"TitleSongPreview" owner:self options:nil] firstObject];
    songPreview.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = songPreview;
    
    UITapGestureRecognizer *tapOnListeningPreview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchPlayerView:)];
    [self.navigationItem.titleView addGestureRecognizer:tapOnListeningPreview];
}

- (void)refreshThePlayerPreview
{
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(refreshPreview) userInfo:nil repeats:YES];
}

- (void)refreshPreview
{
    TitleSongPreview *songPreview = (TitleSongPreview *)self.navigationItem.titleView;
    if (self.player.listeningList.count > 0) {
    
        Music *s = [self.player.listeningList objectAtIndex:self.player.index];
        
        if (self.player.audioPlayer != nil) {
            
        } else {
            [self.player prepareSong:s.identifier];
        }
        
        songPreview.albumImage.image = [UIImage imageNamed:s.albumImage];
        songPreview.trackLabel.text = s.title;
        songPreview.artistLabel.text = s.artist.username;
        
    } else {
        songPreview.albumImage.image = nil;
        songPreview.trackLabel.text = nil;
        songPreview.artistLabel.text = nil;
    }
}

- (void)launchPlayerView:(UITapGestureRecognizer *)reco
{
    [reco locationInView:[reco.view superview]];
    
    if (self.player.listeningList.count > 0) {
        PlayerViewController *vc = [[PlayerViewController alloc] initWithNibName:@"PlayerViewController" bundle:nil];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:@"openPlayer"];
        [self.navigationController pushViewController:vc animated:NO];
    } else {
        SimplePopUp *popUp = [[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"current_list_no_content"] onView:self.view];
        [popUp show];
    }
    
    
}

- (void)closeTheSession
{
    self.prefs = [NSUserDefaults standardUserDefaults];
    [self.prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:nil] forKey:@"User"];
    [self.prefs synchronize];
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    ConnexionViewController *vc = [[ConnexionViewController alloc] initWithNibName:@"ConnexionViewController" bundle:nil];
    
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    (void)[self.navigationController initWithRootViewController:vc];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)closePopUp
{
    for (UIView *v in [self.view subviews]) {
        if (v.tag == 100) {
            [UIView animateWithDuration:1 animations:^{
                v.alpha = 0;
            } completion:^(BOOL finished) {
                [v removeFromSuperview];
            }];
        }
    }
    [self removeBlurEffect:200 onView:self.view];
}

- (void)addBlurEffectOnView:(UIView *)view
{
    [self.navigationController setNavigationBarHidden:true animated:true];
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = view.bounds;
    visualEffectView.tag = 200;
    [view addSubview:visualEffectView];
    visualEffectView.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        visualEffectView.alpha = 1;
    }];
}

- (void)removeBlurEffect:(int)tag onView:(UIView *)v
{
    for (UIView *view in v.subviews) {
        if (view.tag == tag) {
            [UIView animateWithDuration:0.5 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
                [self.navigationController setNavigationBarHidden:false animated:true];
            }];
        }
    }
}

- (void)closeViewController {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)goToAlbumView:(Music *)music {
    [self closePopUp];
    AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
    vc.album = [[Album alloc] init];
    vc.album.identifier = music.albumId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToArtistView:(Music *)music {
    [self closePopUp];
    ArtistViewController *vc = [[ArtistViewController alloc] initWithNibName:@"ArtistViewController" bundle:nil];
    vc.artist = music.artist;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteFromCurrentList:(Music *)music {
    Music *m = [self.player.listeningList objectAtIndex:self.player.index];
    if (m.identifier == music.identifier) {
 //       [self.player pauseSound];
        //self.player.oldIndex = 0;
        self.player.index = 0;
    }
    
    for (int i = 0; i < self.player.listeningList.count; i++) {
        Music *m = [self.player.listeningList objectAtIndex:i];
        if (m.identifier == music.identifier) {
            [self.player.listeningList removeObjectAtIndex:i];
        }
        
    }
    
    NSMutableArray *listeningList = [[NSMutableArray alloc] init];
    for (Music *m in self.player.listeningList) {
        [listeningList addObject:m];
    }
    self.player.listeningList = listeningList;
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)view;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)launchShareView:(id)elem
{
    ShareActionSheet *actionSheet = [[ShareActionSheet alloc] initWithTitle:[self.translate.dict objectForKey:@"choose_social_network"] delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    [actionSheet addButtonWithTitle:@"Facebook"];
    [actionSheet addButtonWithTitle:@"Twitter"];
    actionSheet.delegate = self;
    actionSheet.elem = elem;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(ShareActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            NSLog(@"Facebook");
            [SocialConnect shareOnFacebook:actionSheet.elem onVC:self];
            break;
        case 2:
            NSLog(@"Twitter");
            [SocialConnect shareOnTwitter:actionSheet.elem onVC:self];
            break;
        default:
            break;
    }
}

- (void)refreshDisp {
    
}

@end
