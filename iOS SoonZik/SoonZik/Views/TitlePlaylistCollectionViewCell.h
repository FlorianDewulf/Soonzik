//
//  TitlePlaylistCollectionViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 11/01/2015.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitlePlaylistCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *album1Image;
@property (nonatomic, strong) IBOutlet UIImageView *album2Image;
@property (nonatomic, strong) IBOutlet UIImageView *album3Image;
@property (nonatomic, strong) IBOutlet UIImageView *album4Image;

@property (nonatomic, strong) IBOutlet UIView *containView;

@property (nonatomic, strong) IBOutlet UILabel *playlistTitle;

- (void)initCell;

@end
