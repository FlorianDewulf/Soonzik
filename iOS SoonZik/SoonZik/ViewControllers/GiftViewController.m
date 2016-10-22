//
//  GiftViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 15/01/16.
//  Copyright © 2016 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "GiftViewController.h"
#import "User.h"

@interface GiftViewController ()

@end

@implementation GiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getFriendList];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.view.backgroundColor = DARK_GREY;
    
    self.tableview.backgroundColor = [UIColor clearColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listOfFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    User *friend = [self.listOfFriends objectAtIndex:[indexPath row]];
    cell.textLabel.text = friend.username;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *friend = [self.listOfFriends objectAtIndex:[indexPath row]];
    
    [self.delegate friendSelected:friend];
    [self.navigationController popViewControllerAnimated:true];
}

- (void)getFriendList {
    self.listOfFriends = [[NSMutableArray alloc] init];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSMutableArray *arr = user.friends;
    
    for (User *friend in arr) {
        [self.listOfFriends addObject:friend];
    }
}

@end
