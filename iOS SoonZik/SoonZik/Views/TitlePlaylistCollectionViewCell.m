//
//  TitlePlaylistCollectionViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 11/01/2015.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import "TitlePlaylistCollectionViewCell.h"

@implementation TitlePlaylistCollectionViewCell

- (void)initCell
{
    self.containView.layer.borderWidth = .5;
    self.containView.layer.borderColor = [UIColor grayColor].CGColor;
}

@end
