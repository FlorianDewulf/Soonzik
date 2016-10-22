//
//  TweetCollectionViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 31/08/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendTweetDelegate <NSObject>

- (void)sendTweet:(NSString *)text;

@end

@interface TweetCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UIButton *btn;
@property (nonatomic, assign) id<SendTweetDelegate> delegate;

- (void)initCell;

@end
