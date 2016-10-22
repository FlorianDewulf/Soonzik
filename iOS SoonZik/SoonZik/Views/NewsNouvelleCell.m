//
//  NewsNouvelleCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 18/02/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import "NewsNouvelleCell.h"
#import "Tools.h"
#import "SVGKImage.h"

@implementation NewsNouvelleCell

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
