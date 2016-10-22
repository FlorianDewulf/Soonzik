//
//  VoteButton.m
//  SoonZik
//
//  Created by Maxime Sauvage on 02/03/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import "VoteButton.h"
#import "Tools.h"
#import "SVGKImage.h"

@implementation VoteButton

- (void)initButton:(User *)artist
{
    self.artist = artist;
    self.image.image = [SVGKImage imageNamed:@"check"].UIImage;
    
    self.visualEffect.layer.cornerRadius = 20;
    self.visualEffect.layer.borderWidth = 1;
    self.visualEffect.layer.borderColor = [UIColor whiteColor].CGColor;
    self.visualEffect.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *reco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voteForArtist)];
    [self addGestureRecognizer:reco];
}

- (void)voteForArtist
{
    [self.voteDelegate vote:self.artist];
}

@end
