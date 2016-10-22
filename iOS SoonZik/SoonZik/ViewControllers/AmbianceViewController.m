//
//  AmbianceViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 10/01/16.
//  Copyright © 2016 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "AmbianceViewController.h"
#import "AmbiancesController.h"
#import "Music.h"
#import "AlbumViewController.h"

@interface AmbianceViewController ()

@end

@implementation AmbianceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.listOfMusics = [AmbiancesController getAmbiance:self.ambiance.identifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listOfMusics.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    Music *m = [self.listOfMusics objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = m.title;
    cell.detailTextLabel.text = m.artist.username;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Music *m = [self.listOfMusics objectAtIndex:indexPath.row];
    
    AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
    vc.album = [[Album alloc] init];
    vc.album.identifier = m.albumId;
    vc.fromPack = true;
    [self.navigationController pushViewController:vc animated:true];
}

@end
