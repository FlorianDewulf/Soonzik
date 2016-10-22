//
//  HeaderUserView.m
//  SoonZik
//
//  Created by Maxime Sauvage on 09/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "HeaderUserView.h"

@implementation HeaderUserView

- (void)initHeader {
    self.imageView.layer.cornerRadius = 60;
    self.imageView.layer.borderWidth = 1;
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userLabel.textColor = [UIColor whiteColor];
    self.imageView.layer.masksToBounds = true;
    self.backgroundColor = [UIColor clearColor];
    self.friendsLabel.textColor = [UIColor whiteColor];
    self.friendsLabel.font = SOONZIK_FONT_BODY_VERY_SMALL;
    self.followersLabel.textColor = [UIColor whiteColor];
    self.followersLabel.font = SOONZIK_FONT_BODY_VERY_SMALL;
    self.followsLabel.textColor = [UIColor whiteColor];
    self.followsLabel.font = SOONZIK_FONT_BODY_VERY_SMALL;
}

@end
