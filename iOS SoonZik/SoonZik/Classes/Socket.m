//
//  Socket.m
//  SoonZik
//
//  Created by Maxime Sauvage on 23/09/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Socket.h"
#import "Crypto.h"
#import "WebSocketRailsDispatcher.h"
#import "WebSocketRailsChannel.h"

@implementation Socket {
    WebSocketRailsDispatcher *dispatcher;
}

static Socket *sharedSocket = nil;    // static instance variable

+ (Socket *)sharedCenter {
    if (sharedSocket == nil) {
        sharedSocket = [[Socket alloc] init];
    }
    return sharedSocket;
}

// to call the instance : [[Socket shareCenter] <name of the method>]

// ENVOYER SECURE_KEY ET USER_ID A CHAQUE REQUETE

- (id)init {
    self = [super init];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    self.user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [self connect];
    [self initToServer];
    [self bindEvents];
    
    return self;
}

- (void)connect {
    dispatcher = [WebSocketRailsDispatcher.alloc initWithUrl:[NSURL URLWithString:@"ws://soonzikapi.herokuapp.com/websocket"/*@"ws://lvh.me:3000/websocket"*/]];
    [dispatcher bind:@"connection_opened" callback:^(id data) {
        NSLog(@"Yay! Connected!");
    }];
    [dispatcher connect];
}

- (void)disconnect {
    [dispatcher bind:@"connection_closed" callback:^(id data) {
        NSLog(@"Disconnected!");
    }];
    [dispatcher disconnect];
}

- (void)initToServer {
    
    NSLog(@"initError");
    NSString *key = [Crypto getKey];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%i", self.user.identifier], @"user_id",
                         key, @"secureKey",
                         nil];
    
    [dispatcher trigger:@"init_connection" data:@{@"data": dic} success:^(id data) {
        NSLog(@"INIT CONNECTION DONE");
        
    } failure:^(id data) {
        NSLog(@"ERROR : INIT CONNECTION FAILED");
    }];

}

- (void)bindEvents {
    [dispatcher bind:@"newMsg" callback:^(id data) {
        NSLog(@"%@", data);
        [self.delegate messageHasBeenReceived:[[Message alloc] initWithSocket:(NSDictionary *)data]];
    }];
    
    [dispatcher bind:@"onlineFriends" callback:^(id data) {
        NSLog(@"%@", data);
    }];
    
    [dispatcher bind:@"newOnlineFriends" callback:^(id data) {
        NSLog(@"%@", data);
    }];
    
    [dispatcher bind:@"newOfflineFriends" callback:^(id data) {
        NSLog(@"%@", data);
    }];
}

- (void)whoIsOnline {
    NSString *key = [Crypto getKey];

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%i", self.user.identifier], @"user_id",
                         key, @"secureKey",
                         nil];
    
    [dispatcher trigger:@"who_is_online" data:@{@"data": dic} success:^(id data) {
        NSLog(@"Success event: %@", data);
    } failure:^(id data) {
        NSLog(@"Falure event: %@", data);
    }];
}

- (void)sendMessage:(NSString *)msg toUserId:(int)userID {
    NSString *key = [Crypto getKey];

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%i", self.user.identifier], @"user_id",
                         key, @"secureKey",
                         msg, @"messageValue",
                         [NSString stringWithFormat:@"%i", userID], @"toWho",
                         nil];
   
    [dispatcher trigger:@"messages.send" data:@{@"data": dic} success:^(id data) {
        NSLog(@"Success event: %@", data);
    } failure:^(id data) {
        NSLog(@"Falure event: %@", data);
    }];
}

@end
