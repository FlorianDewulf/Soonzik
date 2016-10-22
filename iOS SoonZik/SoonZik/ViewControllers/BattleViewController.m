//
//  BattleViewController.m
//  SoonZik
//
//  Created by LLC on 23/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "BattleViewController.h"
#import "SVGKImage.h"
#import "Tools.h"
#import "Battle.h"
#import "TopMusic.h"
#import "SimplePopUp.h"
#import "BattlesController.h"

@interface BattleViewController ()

@end

@implementation BattleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = false;
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    while (self.translate.dict == nil) {
        NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
        self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataLoaded = NO;
    [self getData];
    
    self.bestSingleTitleLabel.text = [self.translate.dict objectForKey:@"title_best_singles"];
    
    [self.contentView layoutIfNeeded];
    CGSize size = CGSizeMake(self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    self.scrollView.contentSize = size;
    [self.scrollView addSubview:self.contentView];
    
    self.view.backgroundColor = DARK_GREY;
    self.contentView.backgroundColor = DARK_GREY;
    
    self.endBattleChronoLabel.layer.borderWidth = 1;
    self.endBattleChronoLabel.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)getData {
    self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spin.center = self.view.center;
    [self.view addSubview:self.spin];
    [self.spin startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        [self getDataFromServer];
        NSLog(@"after get data from server");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self.spin stopAnimating];
            self.dataLoaded = true;
            [self initElements];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getChrono:) userInfo:nil repeats:YES];
        });
    });
}

- (void)getChrono:(NSTimer *)timer {
    NSDate *now = [NSDate date];
    // has the target time passed?
    if ([self.battle.endDate earlierDate:now] == self.battle.endDate) {
        [timer invalidate];
        self.endBattleChronoLabel.text = [self.translate.dict objectForKey:@"battle_ended"];
    } else {
        NSUInteger flags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:now toDate:self.battle.endDate options:0];
        self.endBattleChronoLabel.text = [NSString stringWithFormat:[self.translate.dict objectForKey:@"battle_deadline"], [components day], [components hour], [components minute], [components second]];
    }
}

- (void)initElements
{
    self.voteForFirst = (VoteButton *)[[[NSBundle mainBundle] loadNibNamed:@"VoteButton" owner:self options:nil] objectAtIndex:0];
    [self.voteForFirst setFrame:CGRectMake(0, self.firstArtistViewImage.frame.size.height+88/2, 120, 78)];
    [self.voteForFirst initButton:self.battle.artistOne];
    self.voteForFirst.voteDelegate = self;
    [self.contentView addSubview:self.voteForFirst];
    
    [self.contentView bringSubviewToFront:self.voteForFirst];
    self.voteForSecond = (VoteButton *)[[[NSBundle mainBundle] loadNibNamed:@"VoteButton" owner:self options:nil] objectAtIndex:0];
    [self.voteForSecond setFrame:CGRectMake(self.view.frame.size.width-120, self.firstArtistViewImage.frame.size.height+88/2, 120, 78)];
    [self.voteForSecond initButton:self.battle.artistTwo];
    self.voteForSecond.voteDelegate = self;
    [self.contentView addSubview:self.voteForSecond];
    
    UIActivityIndicatorView *spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    dispatch_async(backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, self.battle.artistOne.image];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            self.firstArtistViewImage.image = [UIImage imageWithData:imageData];
            [spin stopAnimating];
        });
        spin.center = self.firstArtistViewImage.center;
        [self.view addSubview:spin];
        [spin startAnimating];
    });
    
    UIActivityIndicatorView *spin2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

    dispatch_queue_t backgroundQueue2 = dispatch_queue_create("com.mycompany.myqueue", 0);
    dispatch_async(backgroundQueue2, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, self.battle.artistTwo.image];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            self.secondArtistViewImage.image = [UIImage imageWithData:imageData];
            [spin2 stopAnimating];
        });
        spin2.center = self.secondArtistViewImage.center;
        [self.view addSubview:spin2];
        [spin2 startAnimating];
    });
    
    self.voteForFirst.tag = self.battle.artistOne.identifier;
    self.voteForFirst.title.text = self.battle.artistOne.username;
    
    self.voteForSecond.tag = self.battle.artistTwo.identifier;
    self.voteForSecond.title.text = self.battle.artistTwo.username;
    
    self.musicArtist1Title.text = self.battle.artistOne.username;
    self.musicArtist1Title.font = SOONZIK_FONT_BODY_MEDIUM;
    self.musicArtist2Title.text = self.battle.artistTwo.username;
    self.musicArtist2Title.font = SOONZIK_FONT_BODY_MEDIUM;
    
    self.musicArtist1Button.titleLabel.font = SOONZIK_FONT_BODY_SMALL;
    self.musicArtist2Button.titleLabel.font = SOONZIK_FONT_BODY_SMALL;
    
    [self refreshProgress];
}

- (void)getDataFromServer
{
    self.firstArtistScoreLabel.font = SOONZIK_FONT_BODY_BIG;
    self.secondArtistScoreLabel.font = SOONZIK_FONT_BODY_BIG;
    NSDate *now = [NSDate date];
    // has the target time passed?
    if ([self.battle.endDate earlierDate:now] == self.battle.endDate) {
        self.endBattleChronoLabel.text = [self.translate.dict objectForKey:@"battle_ended"];
    } else {
        NSUInteger flags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:now toDate:self.battle.endDate options:0];
        /*self.endBattleChronoLabel.text = [NSString stringWithFormat:[self.translate.dict objectForKey:@"battle_deadline"], [components day], [components hour], [components minute], [components second]];*/
    }
   
    float totalVotes = self.battle.voteArtistOne+self.battle.voteArtistTwo;
    self.firstArtistScore = self.battle.voteArtistOne*100/totalVotes;
    self.secondArtistScore = self.battle.voteArtistTwo*100/totalVotes;
    self.firstArtistScoreLabel.text = [NSString stringWithFormat:@"%.1f%%", self.firstArtistScore];
    self.firstArtistScoreLabel.textColor = ORANGE;
    self.secondArtistScoreLabel.text = [NSString stringWithFormat:@"%.1f%%", self.secondArtistScore];
    self.secondArtistScoreLabel.textColor = BLUE_2;
}

- (void)refreshProgress {
    float totalVotes = self.battle.voteArtistOne+self.battle.voteArtistTwo;
    float artist1ViewWidth = self.battle.voteArtistOne*self.chartView.frame.size.width/totalVotes;
    float artist2ViewWidth = self.battle.voteArtistTwo*self.chartView.frame.size.width/totalVotes;
    
    self.firstArtistScore = self.battle.voteArtistOne*100/totalVotes;
    self.secondArtistScore = self.battle.voteArtistTwo*100/totalVotes;
    self.firstArtistScoreLabel.text = [NSString stringWithFormat:@"%.1f%%", self.firstArtistScore];
    self.secondArtistScoreLabel.text = [NSString stringWithFormat:@"%.1f%%", self.secondArtistScore];
    
    UIView *artist1Part = [[UIView alloc] initWithFrame:CGRectMake(0, 0, artist1ViewWidth, self.chartView.frame.size.height)];
    [artist1Part setBackgroundColor:ORANGE];
    [self.chartView addSubview:artist1Part];
    UIView *artist2Part = [[UIView alloc] initWithFrame:CGRectMake(artist1ViewWidth, 0, artist2ViewWidth, self.chartView.frame.size.height)];
    [artist2Part setBackgroundColor:BLUE_2];
    [self.chartView addSubview:artist2Part];
}

- (void)vote:(User *)artist
{
    Battle *b = [BattlesController vote:self.battle.identifier :artist.identifier];
    if (b != nil) {
        if (artist.identifier == self.battle.artistOne.identifier) {
            self.battle.voteArtistOne++;
        } else if (artist.identifier == self.battle.artistTwo.identifier) {
            self.battle.voteArtistTwo++;
        }
        [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"vote_for_artist"], artist.username] onView:self.view withSuccess:true] show];
        [self refreshProgress];
    } else {
        [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"vote_for_artist_error"], artist.username] onView:self.view withSuccess:false] show];
    }
    
    //[self getDataFromServer];
    
}

@end
