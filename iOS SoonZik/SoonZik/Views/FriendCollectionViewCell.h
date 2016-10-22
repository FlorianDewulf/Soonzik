//
//  FriendCollectionViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 02/04/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageV;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

- (void)initCell;

@end
