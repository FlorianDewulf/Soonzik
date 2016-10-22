//
//  FriendCollectionViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 02/04/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import "FriendCollectionViewCell.h"

@implementation FriendCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)initCell {
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.cornerRadius = 40.0f;
    self.imageV.layer.borderWidth = 1;
    self.imageV.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        [UIView transitionWithView:self duration:.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.imageV.layer.borderColor = ORANGE.CGColor;
        } completion:^(BOOL finished) {}];
        
    } else {
        [UIView transitionWithView:self duration:.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.imageV.layer.borderColor = [UIColor grayColor].CGColor;
        } completion:^(BOOL finished) {}];
    }
}

@end
