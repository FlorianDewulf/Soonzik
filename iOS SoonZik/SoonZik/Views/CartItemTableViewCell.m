//
//  CartItemTableViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 18/08/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "CartItemTableViewCell.h"

@implementation CartItemTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.font = SOONZIK_FONT_BODY_MEDIUM;
    self.artistLabel.font = SOONZIK_FONT_BODY_SMALL;
    [self.deleteButton setTintColor:ORANGE];
}

@end
