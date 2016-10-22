//
//  SearchAlbumTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 17/04/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface SearchAlbumTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *albumLabel;
@property (strong, nonatomic) IBOutlet UIImageView *albumImage;

- (void)initCell:(Album *)album;

@end
