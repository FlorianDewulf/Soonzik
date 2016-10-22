//
//  PlayListsCells.m
//  SoonZik
//
//  Created by LLC on 25/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "PlayListsCells.h"

@implementation PlayListsCells

- (void)initCell
{
    self.trackTitle.font = SOONZIK_FONT_BODY_MEDIUM;
    self.trackArtist.font = SOONZIK_FONT_BODY_SMALL;
    self.backgroundColor =  DARK_GREY;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected) {
        self.trackArtist.textColor = BLUE_3;
        self.trackTitle.textColor = BLUE_3;
    }
    else {
        self.trackArtist.textColor = [UIColor whiteColor];
        self.trackTitle.textColor = [UIColor whiteColor];
    }
}

@end
