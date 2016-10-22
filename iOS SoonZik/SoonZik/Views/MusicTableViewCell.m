//
//  MusicTableViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "MusicTableViewCell.h"
#import "SVGKImage.h"
#import "Tools.h"

@implementation MusicTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.musicTitle.font = SOONZIK_FONT_BODY_SMALL;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.musicTitle.textColor = BLUE_3;
        self.musicTitle.font = SOONZIK_FONT_BODY_SMALL;
    } else {
        self.musicTitle.textColor = [UIColor whiteColor];
    }
}

- (void)initCell
{
    [self.optionsButton setBackgroundImage:[Tools imageWithImage:[UIImage imageNamed:@"options_white"] scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
}

@end
