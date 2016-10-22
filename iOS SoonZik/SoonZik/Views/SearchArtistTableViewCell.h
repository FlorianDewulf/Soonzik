//
//  SearchArtistTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 17/04/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface SearchArtistTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UIImageView *artistImage;

- (void)initCell:(User *)artist;

@end
