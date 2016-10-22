//
//  CommentsController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"
#import "News.h"
#import "Crypto.h"

@interface CommentsController : NSObject

+ (NSMutableArray *)getCommentsFromNews:(News *)news;
+ (BOOL)addComment:(News *)news andComment:(NSString *)content;

@end
