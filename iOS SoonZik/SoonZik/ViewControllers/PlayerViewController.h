//
//  PlayerViewController.h
//  SoonZik
//
//  Created by LLC on 13/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"
#import "Music.h"
#import "SWTableViewCell.h"
#import "CurrentListViewController.h"

@interface PlayerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FinishPlayPlayer, SWTableViewCellDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) AudioPlayer *player;
@property (nonatomic, strong) NSMutableArray *listeningList;
@property (nonatomic, strong) IBOutlet UILabel *finishTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, strong) IBOutlet UISlider *progressionSlider;
@property (assign, nonatomic) CGFloat screenWidth;
@property (assign, nonatomic) CGFloat screenHeight;
@property (strong, nonatomic) IBOutlet UILabel *songTitle;
@property (strong, nonatomic) IBOutlet UILabel *songArtist;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) CurrentListViewController *currentListViewController;
@property (strong, nonatomic) IBOutlet UIButton *previousButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *repeatButton;
@property (strong, nonatomic) IBOutlet UIButton *randomButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

- (IBAction)play:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;

- (IBAction)goToThisPeriod:(id)sender;

@end
