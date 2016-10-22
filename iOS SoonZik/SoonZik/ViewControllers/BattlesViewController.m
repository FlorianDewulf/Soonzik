//
//  BattlesViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 26/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "BattlesViewController.h"
#import "BattleViewController.h"
#import "BattleTableViewCell.h"
#import "BattlesController.h"

@interface BattlesViewController ()

@end

@implementation BattlesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.view.backgroundColor = DARK_GREY;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.dataLoaded = NO;
    [self launchLoadData];
}

- (void)launchLoadData {
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
}

- (void) loadData {
    self.dataLoaded = NO;
    [self loadDataFromAPI];
    self.dataLoaded = YES;
    [self.tableView reloadData];
}

- (void)loadDataFromAPI {
    [NSThread detachNewThreadSelector: @selector(spinBegin) toTarget:self withObject:nil];
    
    self.listOfBattles = [BattlesController getAllTheBattles];

    [NSThread detachNewThreadSelector: @selector(spinEnd) toTarget:self withObject:nil];
}

- (void)spinBegin {
    self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spin.center = self.view.center;
    [self.view addSubview:self.spin];
    
    [self.spin startAnimating];
}

- (void)spinEnd {
    [self.spin stopAnimating];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataLoaded) {
        return self.listOfBattles.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BattleTableViewCell *cell = (BattleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"BattleTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
        cell = (BattleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellID"];
    }
    Battle *battle = [self.listOfBattles objectAtIndex:indexPath.row];
    [cell initCell:battle.artistOne :battle.artistTwo];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Battle *battle = [self.listOfBattles objectAtIndex:indexPath.row];
    BattleViewController *battleVC = [[BattleViewController alloc] initWithNibName:@"BattleViewController" bundle:nil];
    battleVC.battle = battle;
    [self.navigationController pushViewController:battleVC animated:true];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:false animated:true];
}

@end
