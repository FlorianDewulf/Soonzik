//
//  BattleViewController.h
//  SoonZik
//
//  Created by LLC on 23/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"
#import "VoteButton.h"
#import "Battle.h"

@interface BattleViewController : TypeViewController <UIGestureRecognizerDelegate, VoteDelegate>

@property (strong, nonatomic) IBOutlet UILabel *firstArtistScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondArtistScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *bestSingleTitleLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UIImageView *firstArtistViewImage;
@property (nonatomic, strong) IBOutlet UIImageView *secondArtistViewImage;
@property (nonatomic, strong) VoteButton *voteForFirst;
@property (nonatomic, strong) VoteButton *voteForSecond;
@property (nonatomic, assign) float firstArtistScore;
@property (nonatomic, assign) float secondArtistScore;
@property (nonatomic, strong) Battle *battle;
@property (nonatomic, strong) IBOutlet UILabel *musicArtist1Title;
@property (nonatomic, strong) IBOutlet UILabel *musicArtist2Title;
@property (nonatomic, strong) IBOutlet UIButton *musicArtist1Button;
@property (nonatomic, strong) IBOutlet UIButton *musicArtist2Button;
@property (nonatomic, strong) IBOutlet UILabel *endBattleChronoLabel;
@property (nonatomic, strong) IBOutlet UILabel *rate1Label;
@property (nonatomic, strong) IBOutlet UILabel *rate2Label;
@property (nonatomic, strong) IBOutlet UIView *chartView;

@property (nonatomic, assign) bool dataLoaded;
@property (nonatomic, strong) UIActivityIndicatorView *spin;

@end
