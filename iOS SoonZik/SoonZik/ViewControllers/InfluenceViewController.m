//
//  InfluenceViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 11/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "InfluenceViewController.h"
#import "GenreViewController.h"
#import "Genre.h"

@interface InfluenceViewController ()

@end

@implementation InfluenceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = false;
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = false;
    self.navigationItem.leftBarButtonItems = nil;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = DARK_GREY;
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.influence.listOfGenres.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID1"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID1"];
        Genre *genre = [self.influence.listOfGenres objectAtIndex:indexPath.row];
        cell.textLabel.text = genre.name;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Genre *genre = [self.influence.listOfGenres objectAtIndex:indexPath.row];
    GenreViewController *genreVC = [[GenreViewController alloc] init];
    genreVC.genre = genre;
    [self.navigationController pushViewController:genreVC animated:true];
}

@end
