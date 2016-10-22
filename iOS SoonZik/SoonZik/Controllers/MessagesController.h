//
//  MessagesController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 25/09/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessagesController : NSObject

+ (NSMutableArray *)getMessagesWithFriendId:(int)userID withOffset:(int)offset;

@end
