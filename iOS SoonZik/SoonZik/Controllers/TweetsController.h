//
//  TweetsController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 25/08/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@interface TweetsController : NSObject

+ (BOOL)sendTweet:(NSString *)message;
+ (NSMutableArray *)getTweets:(int)userId;

@end
