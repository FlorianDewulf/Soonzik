//
//  SearchAlbumTableViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 17/04/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import "SearchAlbumTableViewCell.h"

@implementation SearchAlbumTableViewCell

- (void)initCell:(Album *)album {
    self.albumLabel.text = album.title;
    self.albumImage.image = [UIImage imageNamed:album.image];
}

@end
