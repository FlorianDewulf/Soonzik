//
//  TweetCollectionViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 31/08/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TweetCollectionViewCell.h"

@implementation TweetCollectionViewCell

- (void)initCell {
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5.0f;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = [UIColor whiteColor];
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(sendTweet) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sendTweet {
    [self.delegate sendTweet:self.textView.text];
    self.textView.text = @"";
}

@end
