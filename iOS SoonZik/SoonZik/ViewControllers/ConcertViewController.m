//
//  ConcertViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 01/09/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ConcertViewController.h"
#import "ConcertHeaderView.h"
#import "ArtistViewController.h"
#import "LikesController.h"
#import "SimplePopUp.h"

@interface ConcertViewController ()

@end

@implementation ConcertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DARK_GREY;
    self.navigationItem.hidesBackButton = false;
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.rightBarButtonItems = nil;
    
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 122;
    }
    
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ConcertHeaderView *header = (ConcertHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"ConcertHeaderView" owner:self options:nil] firstObject];
        [header initHeader:self.concert];
        [header.shareButton addTarget:self action:@selector(launchShareView) forControlEvents:UIControlEventTouchUpInside];
        [header.artistButton addTarget:self action:@selector(goToArtistView) forControlEvents:UIControlEventTouchUpInside];

        UIButton *likeButton = [[UIButton alloc] initWithFrame:CGRectMake(header.frame.size.width-30-30-30-10, header.frame.size.height - 40, 30, 30)];
        if (self.concert.isLiked) {
            [likeButton setImage:[Tools imageWithImage:[UIImage imageNamed:@"love_1"] scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
        } else {
            [likeButton setImage:[Tools imageWithImage:[UIImage imageNamed:@"love_0"] scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
        }
        [likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        [likeButton setTintColor:[UIColor whiteColor]];
        [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [header addSubview:likeButton];
        
        return header;
    }
    
    return nil;
}

- (void)like:(UIButton *)btn {
    if (self.concert.isLiked) {
        // send dislike
        if (![LikesController dislike:self.concert.identifier forObjectType:@"Concerts"]) {
            [[[SimplePopUp alloc] initWithMessage:@"An error occured on this action" onView:self.view withSuccess:false] show];
        } else {
            [btn setImage:[Tools imageWithImage:[UIImage imageNamed:@"love_0"] scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
            self.concert.isLiked = false;
        }
    } else {
        // send like
        if (![LikesController like:self.concert.identifier forObjectType:@"Concerts"]) {
            [[[SimplePopUp alloc] initWithMessage:@"An error occured on this action" onView:self.view withSuccess:false] show];
        } else {
            [btn setImage:[Tools imageWithImage:[UIImage imageNamed:@"love_1"] scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
            self.concert.isLiked = true;
        }
    }
    // get album info
    //reload tableView
}

- (void)launchShareView {
    [self launchShareView:self.concert];
}

- (void)goToArtistView
{
    ArtistViewController *vc = [[ArtistViewController alloc] initWithNibName:@"ArtistViewController" bundle:nil];
    vc.artist = self.concert.artist;
    vc.fromNav = true;
    [self.navigationController pushViewController:vc animated:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 0;
    else if (section == 1)
        return 1;
    else if (section == 2)
        return 3;
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1)
        return 44;
    else if (indexPath.section == 2)
        return 30;
    
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1)
        return @"Date";
    else if (section == 2)
        return @"Adresse";
    
    return @"Plus d'infos";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.concert.date];
            cell.textLabel.text = [NSString stringWithFormat:@"Le %.2i/%.2i/%.4i", components.day, components.month, components.year];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.concert.address.streetNbr, self.concert.address.street];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.concert.address.zipCode, self.concert.address.city];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.concert.address.country];
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", self.concert.url];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = SOONZIK_FONT_BODY_SMALL;
    
    
    return cell;
}

@end
