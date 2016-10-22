//
//  IdenticationsController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 03/09/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "IdenticationsController.h"


@implementation IdenticationsController

+ (User *)emailConnect:(NSString *)email andPassword:(NSString *)password
{
    NSString *url = [NSString stringWithFormat:@"%@login/", API_URL];
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", email, password];
    NSDictionary *json = [Request postRequest:post url:url];
    
    if ([[json objectForKey:@"code"] intValue] == 502) {
        return nil;
    }
    
    User *user = [[User alloc] initWithJsonObject:[json objectForKey:@"content"]];
    return user;
}

+ (User *)facebookConnect:(NSString *)token email:(NSString *)email uid:(NSString *)uid
{
    NSString *tok = [self getSocialToken:uid andType:@"facebook"];
    NSString *url, *post, *conca, *secureKey;
    
    url = [NSString stringWithFormat:@"%@social-login", API_URL];
    conca = [NSString stringWithFormat:@"%@%@%@", uid, tok, FIX_SALT];
    secureKey = [Crypto sha256HashFor:conca];
    post = [NSString stringWithFormat:@"uid=%@&provider=%@&encrypted_key=%@&token=%@", uid, @"facebook", secureKey, token];
    
    NSDictionary *json = [Request postRequest:post url:url];
    
    NSLog(@"json facebook connect : %@", json);
    
    User *user = [[User alloc] initWithJsonObject:[json objectForKey:@"content"]];
    
    return user;
}

+ (User *)twitterConnect:(NSString *)token uid:(NSString *)uid
{
    NSString *tok = [self getSocialToken:uid andType:@"twitter"];
    NSString *url, *post, *conca, *secureKey;
    
    url = [NSString stringWithFormat:@"%@social-login", API_URL];
    conca = [NSString stringWithFormat:@"%@%@%@", uid, tok, FIX_SALT];
    secureKey = [Crypto sha256HashFor:conca];
    post = [NSString stringWithFormat:@"uid=%@&provider=%@&encrypted_key=%@&token=%@", uid, @"twitter", secureKey, token];
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"json twitter : %@", json);
    User *user = [[User alloc] initWithJsonObject:[json objectForKey:@"content"]];
    
    return user;
}

+ (User *)googleConnect:(NSString *)token uid:(NSString *)uid
{
    NSString *tok = [self getSocialToken:uid andType:@"google"];
    NSString *url, *post, *conca, *secureKey;
    
    url = [NSString stringWithFormat:@"%@social-login", API_URL];
    conca = [NSString stringWithFormat:@"%@%@%@", uid, tok, FIX_SALT];
    secureKey = [Crypto sha256HashFor:conca];
    post = [NSString stringWithFormat:@"uid=%@&provider=%@&encrypted_key=%@&token=%@", uid, @"google", secureKey, token];
    
    NSDictionary *json = [Request postRequest:post url:url];
    User *user = [[User alloc] initWithJsonObject:[json objectForKey:@"content"]];
    
    return user;
}

+ (NSString *)getSocialToken:(NSString *)uid andType:(NSString *)type {
    NSString *url = [NSString stringWithFormat:@"%@getSocialToken/%@/%@", API_URL, uid, type];
    
    NSDictionary *results = [Request getRequest:url];
    return (NSString *)[results objectForKey:@"key"];
}

+ (User *)subscribe:(User *)user {
    NSString *url = [NSString stringWithFormat:@"%@users/save", API_URL];
    NSString *post = [NSString stringWithFormat:@"user[email]=%@&user[password]=%@&user[username]=%@&user[birthday]=%@&user[language]=%@&user[fname]=%@&user[lname]=%@", user.email, user.password, user.username, user.birthday, user.language, user.firstname, user.lastname];
    NSDictionary *json = [Request postRequest:post url:url];
    
    if ([[json objectForKey:@"code"] intValue] == 201) {
        User *user = [[User alloc] initWithJsonObject:[json objectForKey:@"content"]];
        return user;
    }
    
    return nil;
}

+ (NSMutableArray *)getLanguages {
    NSString *url = [NSString stringWithFormat:@"%@languages", API_URL];
    NSDictionary *json = [Request getRequest:url];
    NSMutableArray *res = [[NSMutableArray alloc] init];
    NSArray *listOfListenings = [json objectForKey:@"content"];
    for (NSDictionary *dict in listOfListenings) {
        [res addObject:[[Language alloc] initWithJsonObject:dict]];
    }
    
    return res;
}

@end
