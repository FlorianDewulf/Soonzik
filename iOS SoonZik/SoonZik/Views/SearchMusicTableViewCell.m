//
//  SearchMusicTableViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 17/04/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import "SearchMusicTableViewCell.h"

@implementation SearchMusicTableViewCell

- (void)initCell:(id)elem {
    if ([elem isKindOfClass:[Music class]]) {
        Music *m = (Music *)elem;
        self.musicLabel.text = m.title;
    } else if ([elem isKindOfClass:[Pack class]]) {
        Pack *m = (Pack *)elem;
        self.musicLabel.text = m.title;
    }
    
}

@end
