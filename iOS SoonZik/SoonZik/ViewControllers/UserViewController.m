//
//  UserViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 09/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "UserViewController.h"
#import "SVGKImage.h"
#import "Tools.h"
#import "HeaderUserView.h"
#import "UsersController.h"
#import "SimplePopUp.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 4, 36, 36)];
    [closeButton setImage:[SVGKImage imageNamed:@"delete"].UIImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    if (self.fromSearch) {
        closeButton.hidden = true;
        self.navigationController.navigationBarHidden = false;
        [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DARK_GREY;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    NSData *meData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    self.me = [NSKeyedUnarchiver unarchiveObjectWithData:meData];
    
    self.dataLoaded = false;
    [self getData];
}

- (void)getData {
    self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spin.center = self.view.center;
    [self.view addSubview:self.spin];
    [self.spin startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        self.user = [UsersController getUser:self.user.identifier];
        self.user.friends = [UsersController getFriends];
        self.user.follows = [UsersController getFollows :self.user.identifier];
        self.listOffollowers = [UsersController getFollowers: self.user.identifier];
        self.followed = false;
        for (User *u in self.listOffollowers) {
            if (u.identifier == self.me.identifier) {
                self.followed = true;
            }
        }
        self.isFriend = false;
        for (User *u in self.me.friends) {
            if (u.identifier == self.user.identifier) {
                self.isFriend = true;
            }
        }
        
        NSLog(@"followed : %i", self.followed);
        NSLog(@"friend : %i", self.isFriend);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self.spin stopAnimating];
            self.dataLoaded = true;
            [self.tableView reloadData];
        });
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 270;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderUserView *view = (HeaderUserView *)[[[NSBundle mainBundle] loadNibNamed:@"HeaderUserView" owner:self options:nil] firstObject];
    [view initHeader];
    view.userLabel.text = self.user.username;
    if (self.user.friends.count <= 1) {
        view.friendsLabel.text = [NSString stringWithFormat:@"%i ami", self.user.friends.count];
    } else {
        view.friendsLabel.text = [NSString stringWithFormat:@"%i amis", self.user.friends.count];
    }
    if (self.user.follows.count <= 1) {
        view.followsLabel.text = [NSString stringWithFormat:@"%i follow", self.user.follows.count];
    } else {
        view.followsLabel.text = [NSString stringWithFormat:@"%i follows", self.user.follows.count];
    }
    if (self.user.followers.count <= 1) {
        view.followersLabel.text = [NSString stringWithFormat:@"%i follower", self.user.followers.count];
    } else {
        view.followersLabel.text = [NSString stringWithFormat:@"%i followers", self.user.followers.count];
    }
    
    if (self.isFriend) {
        [view.friendButton setTitle:@"Enlever des amis" forState:UIControlStateNormal];
    } else {
        [view.friendButton setTitle:@"Ajouter en ami" forState:UIControlStateNormal];
    }
    
    if (self.followed) {
        [view.followButton setTitle:@"Ne plus suivre" forState:UIControlStateNormal];
    } else {
        [view.followButton setTitle:@"Suivre" forState:UIControlStateNormal];
    }
    
    NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, self.user.image];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
    view.imageView.image = [UIImage imageWithData:imageData];
    
    [view.followButton addTarget:self action:@selector(addToFollow:) forControlEvents:UIControlEventTouchUpInside];
    [view.friendButton addTarget:self action:@selector(addToFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = @"Description";
    if (self.user.desc) {
        cell.detailTextLabel.text = @"";
    } else {
        cell.detailTextLabel.text = @"";
    }
    
    [cell sizeToFit];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = SOONZIK_FONT_BODY_SMALL;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)addToFollow:(UIButton *)btn {
    if (self.followed) {
        if ([UsersController unfollow:self.user.identifier]) {
            [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"unfollow_artist"], self.user.username] onView:self.view withSuccess:true] show];
            [btn setTitle:@"Suivre" forState:UIControlStateNormal];
            self.followed = false;
        } else {
            [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"playlist_deleted_error"] onView:self.view withSuccess:false] show];
        }
    } else {
        if ([UsersController follow:self.user.identifier]) {
            [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"follow_artist"], self.user.username] onView:self.view withSuccess:true] show];
            [btn setTitle:@"Ne plus suivre" forState:UIControlStateNormal];
            self.followed = true;
        } else {
            [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"playlist_deleted_error"] onView:self.view withSuccess:false] show];
        }
    }
}

- (void)addToFriend:(UIButton *)btn {
    if (self.isFriend) {
        if ([UsersController delFriend:self.user.identifier]) {
            for (int i =0; i<self.me.friends.count; i++) {
                User *friend = [self.me.friends objectAtIndex:i];
                if (friend.identifier == self.user.identifier) {
                    [self.me.friends removeObjectAtIndex:i];
                }
            }
            NSData *dataStore = [NSKeyedArchiver archivedDataWithRootObject:self.me];
            [[NSUserDefaults standardUserDefaults] setObject:dataStore forKey:@"User"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"del_friend"], self.user.username] onView:self.view withSuccess:true] show];
            [btn setTitle:@"Ajouter en ami" forState:UIControlStateNormal];
            self.isFriend = false;
        } else {
            [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"playlist_deleted_error"] onView:self.view withSuccess:false] show];
        }
    } else {
        if ([UsersController addFriend:self.user.identifier]) {
            [self.me.friends addObject:self.user];
            NSData *dataStore = [NSKeyedArchiver archivedDataWithRootObject:self.me];
            [[NSUserDefaults standardUserDefaults] setObject:dataStore forKey:@"User"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"add_friend"], self.user.username] onView:self.view withSuccess:true] show];
            [btn setTitle:@"Enlever des amis" forState:UIControlStateNormal];
            self.isFriend = true;
        } else {
           [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"playlist_deleted_error"] onView:self.view withSuccess:false] show];
        }
    }
}

@end
