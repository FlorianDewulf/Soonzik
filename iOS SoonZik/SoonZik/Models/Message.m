//
//  Message.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Message.h"
#import "User.h"

@implementation Message

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *data = [prefs objectForKey:@"User"];
    User *me = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if ([[json objectForKey:@"user_id"] intValue] == me.identifier) {
        self.fromUser = me;
        self.fromMe = true;
    } else {
        self.fromUser = [[User alloc] init];
        self.fromUser.identifier = [[json objectForKey:@"dest_id"] intValue];
        self.fromMe = false;
    }
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.content = [json objectForKey:@"msg"];
    self.text = [json objectForKey:@"msg"];
    
    if ([[json objectForKey:@"dest_id"] intValue] == me.identifier) {
        self.toUser = me;
    } else {
        self.toUser = [[User alloc] init];
        self.toUser.identifier = [[json objectForKey:@"dest_id"] intValue];
    }
    
    NSLog(@"json : %@", json);
    
    return self;
}

- (id)initWithSocket:(NSString *)sock {
    self = [super init];
    
    self.fromMe = false;
    NSLog(@"sock : %@", sock);
    NSData *data = [sock dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    self.fromUsername = [json objectForKey:@"from"];
    self.content = [json objectForKey:@"message"];
    
    return self;
}

@end
