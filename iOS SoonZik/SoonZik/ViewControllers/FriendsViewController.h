//
//  FriendsViewController.h
//  SoonZik
//
//  Created by LLC on 09/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"
#import "TweetCollectionViewCell.h"
#import "Socket.h"

@interface FriendsViewController : TypeViewController <UICollectionViewDataSource, UICollectionViewDelegate, SendTweetDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collecView;
@property (nonatomic, strong) NSMutableArray *listOfFriendsTitle;
@property (nonatomic, strong) NSMutableArray *listOfFriendsTMP;
@property (nonatomic, strong) NSMutableArray *listOfFriends;
@property (nonatomic, strong) NSMutableArray *listOfFollowsTitle;
@property (nonatomic, strong) NSMutableArray *listOfFollowsTMP;
@property (nonatomic, strong) NSMutableArray *listOfFollows;
@property (nonatomic, strong) NSMutableArray *listOfFollowersTitle;
@property (nonatomic, strong) NSMutableArray *listOfFollowersTMP;
@property (nonatomic, strong) NSMutableArray *listOfFollowers;
@property (nonatomic, assign) int selectedCell;
@property (nonatomic, assign) int selectedCellOld;
@property (nonatomic, assign) BOOL selected;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIButton *chatButton;
@property (strong, nonatomic) IBOutlet UIButton *pageButton;
@property (strong, nonatomic) User *selectedFriend;
@property (strong, nonatomic) IBOutlet UIView *toolbar;
@property (strong, nonatomic) Socket *socket;

@property (nonatomic, assign) bool dataLoaded;
@property (nonatomic, strong) UIActivityIndicatorView *spin;

@end
