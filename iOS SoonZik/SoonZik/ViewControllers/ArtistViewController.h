//
//  ArtistViewController.h
//  SoonZik
//
//  Created by LLC on 04/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeViewController.h"
#import "User.h"

@interface ArtistViewController : TypeViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) User *artist;
@property (nonatomic, strong) User *user;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listOfAlbums;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *visualEffectView;
@property (strong, nonatomic) IBOutlet UILabel *artistName;
@property (strong, nonatomic) IBOutlet UIImageView *artistImage;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UIButton *friendButton;
@property (nonatomic, assign) bool followed;
@property (nonatomic, assign) bool isFriend;
@property (nonatomic, assign) bool fromNav;
@property (nonatomic, assign) bool fromSearch;
@property (nonatomic, assign) bool fromCurrentList;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *listOfTweets;

@property (nonatomic, assign) bool dataLoaded;
@property (nonatomic, strong) UIActivityIndicatorView *spin;

@end
