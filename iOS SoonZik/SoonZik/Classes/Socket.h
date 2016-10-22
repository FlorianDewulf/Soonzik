//
//  Socket.h
//  SoonZik
//
//  Created by Maxime Sauvage on 23/09/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "SRWebSocket.h"
#import "Message.h"

@protocol MessageReceivedDelegate <NSObject>
- (void)messageHasBeenReceived:(Message *)msg;
@end

@interface Socket : NSObject

@property (strong, nonatomic) User *user;

+ (Socket *)sharedCenter;

- (void)sendMessage:(NSString *)msg toUserId:(int)userID;
- (void)whoIsOnline;

@property (strong, nonatomic) id<MessageReceivedDelegate> delegate;

@end
