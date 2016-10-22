//
//  UserViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TypeViewController.h"
#import "User.h"

@interface UserViewController : TypeViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) User *me;
@property (nonatomic, assign) BOOL fromSearch;
@property (nonatomic, strong) NSArray *listOffollowers;
@property (nonatomic, assign) bool followed;
@property (nonatomic, assign) bool isFriend;

@property (nonatomic, assign) bool dataLoaded;
@property (nonatomic, strong) UIActivityIndicatorView *spin;

@end
