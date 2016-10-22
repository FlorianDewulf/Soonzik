//
//  UsersController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Address.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "User.h"
#import "Music.h"
#import "Album.h"
#import "Pack.h"
#import "BoughtContent.h"

@interface UsersController : NSObject

+ (BOOL)follow:(int)artistId;
+ (BOOL)unfollow:(int)artistId;
+ (NSMutableArray *)getFollows :(int)userID;
+ (NSMutableArray *)getFollowers :(int)userID;
+ (NSMutableArray *)getFriends;
+ (BOOL)addFriend:(int)userID;
+ (BOOL)delFriend:(int)userID;
+ (BOOL)isArtist:(int)userID;
+ (User *)getUser:(int)userID;
+ (BoughtContent *)getContent;
+ (NSMutableArray *)getUsersInArea:(double)latitude :(double)longitude :(int)range;
+ (User *)update:(User *)user;
+ (BOOL)sendFeedback:(NSString *)mail type:(NSString *)type object:(NSString *)object text:(NSString *)text;


@end
