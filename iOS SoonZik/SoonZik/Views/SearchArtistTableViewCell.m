//
//  SearchArtistTableViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 17/04/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import "SearchArtistTableViewCell.h"

@implementation SearchArtistTableViewCell

- (void)initCell:(User *)artist {
    self.artistLabel.text = artist.username;
    self.artistImage.image = [UIImage imageNamed:artist.image];
}
    

@end
