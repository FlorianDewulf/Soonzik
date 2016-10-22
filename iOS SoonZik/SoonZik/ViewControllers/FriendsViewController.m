//
//  FriendsViewController.m
//  SoonZik
//
//  Created by LLC on 09/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendCollectionViewCell.h"
#import "ArtistViewController.h"
#import "ChatViewController.h"
#import "CollectionReusableView.h"
#import "User.h"
#import "SVGKImage.h"
#import "Tools.h"
#import "UsersController.h"
#import "TweetsController.h"
#import "SimplePopUp.h"

@interface FriendsViewController ()
{
    BOOL toolbarOpened;
}

@end

@implementation FriendsViewController

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataLoaded = NO;
    [self getData];
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.collecView.delegate = self;
    self.collecView.dataSource = self;
    [self.collecView registerNib:[UINib nibWithNibName:@"FriendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.collecView registerNib:[UINib nibWithNibName:@"TweetCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"tweetCell"];
    [self.collecView registerNib:[UINib nibWithNibName:@"CollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    self.collecView.backgroundColor = [UIColor clearColor];
    
    self.selectedCell = -10;
    self.selectedCellOld = -10;
    self.selected = NO;
    
    self.toolbar.backgroundColor = [UIColor darkGrayColor];
    self.view.backgroundColor = DARK_GREY;
    [self.pageButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"user_white"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [self.pageButton setTintColor:[UIColor whiteColor]];
    [self.pageButton addTarget:self action:@selector(goToView) forControlEvents:UIControlEventTouchUpInside];
    [self.chatButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"chat"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [self.chatButton setTintColor:[UIColor whiteColor]];
    [self.chatButton addTarget:self action:@selector(goToChat) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolbar setFrame:CGRectMake(0, self.view.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height)];
    [self.collecView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    toolbarOpened = NO;
}

- (void)getData {
    self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spin.center = self.view.center;
    [self.view addSubview:self.spin];
    [self.spin startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        [self getFriendList];
        [self getFollowsList];
        [self getFollowersList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self.spin stopAnimating];
            self.dataLoaded = true;
            [self.collecView reloadData];
        });
    });
}

- (void)goToChat
{
    ChatViewController *chatVC = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    chatVC.friend = self.selectedFriend;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)goToView
{
    
}

- (void)getFollowersList
{
    self.listOfFollowersTMP = [[NSMutableArray alloc] init];
    self.listOfFollowersTitle = [[NSMutableArray alloc] init];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSMutableArray *arr = [UsersController getFollowers :user.identifier];
    
    for (User *follower in arr) {
        [self.listOfFollowersTitle addObject:follower.username];
        [self.listOfFollowersTMP addObject:follower];
    }
    
    [self getFollowerListInOrder];
}

- (void)getFollowerListInOrder
{
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [self.listOfFollowersTitle sortUsingDescriptors:[NSArray arrayWithObject:sortOrder]];
    
    self.listOfFollowers = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.listOfFollowersTitle.count; i++) {
        for (int j = 0; j < self.listOfFollowersTMP.count; j++) {
            User *p = [self.listOfFollowersTMP objectAtIndex:j];
            if ([p.username isEqualToString:[self.listOfFollowersTitle objectAtIndex:i]]) {
                [self.listOfFollowers addObject:p];
            }
        }
    }
}

- (void)getFollowsList {
    self.listOfFollowsTMP = [[NSMutableArray alloc] init];
    self.listOfFollowsTitle = [[NSMutableArray alloc] init];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSMutableArray *arr = [UsersController getFollows :user.identifier];
    
    for (User *follow in arr) {
        [self.listOfFollowsTitle addObject:follow.username];
        [self.listOfFollowsTMP addObject:follow];
    }
    
    [self getFollowListInOrder];
}

- (void)getFollowListInOrder {
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [self.listOfFollowsTitle sortUsingDescriptors:[NSArray arrayWithObject:sortOrder]];
    
    self.listOfFollows = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.listOfFollowsTitle.count; i++) {
        for (int j = 0; j < self.listOfFollowsTMP.count; j++) {
            User *p = [self.listOfFollowsTMP objectAtIndex:j];
            if ([p.username isEqualToString:[self.listOfFollowsTitle objectAtIndex:i]]) {
                [self.listOfFollows addObject:p];
            }
        }
    }
}

- (void)getFriendList {
    self.listOfFriendsTMP = [[NSMutableArray alloc] init];
    self.listOfFriendsTitle = [[NSMutableArray alloc] init];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSMutableArray *arr = user.friends;
    
    for (User *friend in arr) {
        [self.listOfFriendsTitle addObject:friend.username];
        [self.listOfFriendsTMP addObject:friend];
    }
    
    [self getFriendListInOrder];
}

- (void)getFriendListInOrder {
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
    [self.listOfFriendsTitle sortUsingDescriptors:[NSArray arrayWithObject:sortOrder]];
    
    self.listOfFriends = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.listOfFriendsTitle.count; i++) {
        for (int j = 0; j < self.listOfFriendsTMP.count; j++) {
            User *p = [self.listOfFriendsTMP objectAtIndex:j];
            if ([p.username isEqualToString:[self.listOfFriendsTitle objectAtIndex:i]]) {
                [self.listOfFriends addObject:p];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataLoaded) {
        if (section == 1)
            return self.listOfFriends.count;
        else if (section == 2)
            return self.listOfFollows.count;
        else if (section == 3)
            return self.listOfFollowers.count;
        else if (section == 0)
            return 1;
    }
    
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(self.view.frame.size.width, 77);
    }
    
    return CGSizeMake(100, 120);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TweetCollectionViewCell *collec = (TweetCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"tweetCell" forIndexPath:indexPath];
        [collec initCell];
        collec.delegate = self;
        
        return collec;
    }
    
    FriendCollectionViewCell *collec = (FriendCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    User *f;
    if (indexPath.section == 1) {
        f = [self.listOfFriends objectAtIndex:indexPath.row];
    } else if (indexPath.section == 2) {
        f = [self.listOfFollows objectAtIndex:indexPath.row];
    } else if (indexPath.section == 3) {
        f = [self.listOfFollowers objectAtIndex:indexPath.row];
    }
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    dispatch_async(backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, f.image];
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            collec.imageV.image = [UIImage imageWithData: imageData];
        });
    });
    collec.nameLabel.text = f.username;
    collec.tag = indexPath.row;
    [collec initCell];
    
    return collec;
}

- (void)sendTweet:(NSString *)text {
    if ([TweetsController sendTweet:text]) {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"tweet_sended"] onView:self.view withSuccess:true] show];
    } else {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"tweet_sended_error"] onView:self.view withSuccess:false] show];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSString *title;
        if (indexPath.section == 0) {
            title = [self.translate.dict objectForKey:@"let_message_to_followers"];
            headerView.imageV.hidden = true;
            headerView.numberLabel.hidden = true;
            headerView.titleL.font = SOONZIK_FONT_BODY_SMALL;
        }
        if (indexPath.section == 1) {
            title = [self.translate.dict objectForKey:@"title_friends"];
            headerView.imageV.hidden = true;
            headerView.numberLabel.hidden = true;
            headerView.titleL.font = SOONZIK_FONT_BODY_MEDIUM;
        }
        if (indexPath.section == 2) {
            title = [self.translate.dict objectForKey:@"title_follows"];
            headerView.imageV.image = [SVGKImage imageNamed:@"people_white"].UIImage;
            headerView.numberLabel.text = [[NSString alloc] initWithFormat:@"%i", self.listOfFollows.count];
            headerView.titleL.font = SOONZIK_FONT_BODY_MEDIUM;
        }
        if (indexPath.section == 3) {
            title = [self.translate.dict objectForKey:@"title_followers"];
            headerView.imageV.image = [SVGKImage imageNamed:@"people_white"].UIImage;
            headerView.numberLabel.text = [[NSString alloc] initWithFormat:@"%i", self.listOfFollowers.count];
            headerView.titleL.font = SOONZIK_FONT_BODY_MEDIUM;
        }
        headerView.titleL.text = title;
        reusableview = headerView;
    }
    
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        self.selectedCellOld = self.selectedCell;
        self.selectedCell = indexPath.row;
        
        User *friend = [self.listOfFriends objectAtIndex:indexPath.row];
        self.usernameLabel.text = friend.username;
        self.selectedFriend = friend;
        
        [self openToolbar];
    } else if (indexPath.section == 2 || indexPath.section == 3) {
        FriendCollectionViewCell *cell = (FriendCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell setSelected:false];
        
        [self closeToolbar];
    }
}

- (void)openToolbar
{
    if (!toolbarOpened) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.toolbar setFrame:CGRectMake(0, self.view.frame.size.height-self.toolbar.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height)];
            [self.collecView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.toolbar.frame.size.height)];
        } completion:nil];
        
        toolbarOpened = YES;
    }
}

- (void)closeToolbar {
    if (toolbarOpened) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.toolbar setFrame:CGRectMake(0, self.view.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height)];
            [self.collecView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        } completion:nil];
        
        toolbarOpened = false;
    }
}


@end
