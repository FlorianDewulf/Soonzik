//
//  TitleAlbumsTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 10/12/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleAlbumsTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *albumImage;
@property (nonatomic, strong) IBOutlet UILabel *albumTitle;
@property (nonatomic, strong) IBOutlet UILabel *albumArtist;

@end
