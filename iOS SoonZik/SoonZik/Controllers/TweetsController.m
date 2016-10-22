//
//  TweetsController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 25/08/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TweetsController.h"
#import "Tweet.h"
#import "User.h"

@implementation TweetsController

+ (BOOL)sendTweet:(NSString *)message {
    NSString *url, *post, *key;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@tweets/save", API_URL];
    key = [Crypto getKey];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&tweet[user_id]=%i&tweet[msg]=%@", user.identifier, key, user.identifier, message];
    
    NSDictionary *json = [Request postRequest:post url:url];
    if ([[json objectForKey:@"code"] intValue] == 201) {
        return true;
    }
    
    return false;
}

+ (NSMutableArray *)getTweets:(int)userId {
    NSString *url, *key;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    url = [NSString stringWithFormat:@"%@tweets/find?attribute[user_id]=%i", API_URL, userId];
    key = [Crypto getKey];
    
    NSDictionary *json = [Request getRequest:url];
    if ([[json objectForKey:@"code"] intValue] == 200) {
        for (NSDictionary *dict in [json objectForKey:@"content"]) {
            [arr addObject:[[Tweet alloc] initWithJsonObject:dict]];
        }
    }
    
    return arr;
}

@end
