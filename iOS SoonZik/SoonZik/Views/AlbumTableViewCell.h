//
//  AlbumTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/12/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *albumLabel;
@property (nonatomic, strong) IBOutlet UIImageView *albumImage;

@end
