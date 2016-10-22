//
//  MenuTableViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 01/11/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    self.lbl.font = SOONZIK_FONT_BODY_MEDIUM;
    self.lbl.textColor = [UIColor whiteColor];
    self.lbl.highlightedTextColor = [UIColor lightGrayColor];
    self.selectedBackgroundView = [[UIView alloc] init];
    self.lbl.textAlignment = NSTextAlignmentLeft;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        //NSLog(@"selected");
        self.lbl.textColor = ORANGE;
        
    } else {
        //NSLog(@"not selected");
        self.lbl.textColor = [UIColor whiteColor];
    }
}

@end
