//
//  NewsTypeAlbumCell.m
//  SoonZik
//
//  Created by LLC on 08/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "NewsTypeAlbumCell.h"
#import "Tools.h"
#import "SVGKImage.h"
#import <QuartzCore/QuartzCore.h>

@implementation NewsTypeAlbumCell

- (void)initCellWithNews:(News *)news
{
    self.news = news;
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 0.5;
    
    [self.shareButton addTarget:self action:@selector(launchShareView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleLabel setText:news.type];
    [self.subtitleLabel setText:news.title];
    [self.dateLabel setText:news.date];
}

- (void)launchShareView
{
    [self.shareDelegate launchShareView:self.news];
}

@end
