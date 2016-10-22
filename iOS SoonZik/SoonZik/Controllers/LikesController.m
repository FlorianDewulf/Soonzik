//
//  LikesController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/11/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "LikesController.h"
#import "User.h"
#import "Crypto.h"

@implementation LikesController

+ (BOOL)like:(int)identifier forObjectType:(NSString *)type {
    NSString *url, *key, *post;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@likes/save", API_URL];
    key = [Crypto getKey];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&like[user_id]=%i&like[typeObj]=%@&like[obj_id]=%i", user.identifier, key, user.identifier, type, identifier];
    
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"json LIKE : %@", json);
    NSLog(@"url LIKE : %@?%@", url, post);
    
    if ([[json objectForKey:@"code"] integerValue] == 201) {
        return true;
    }
    
    return false;
}

+ (BOOL)dislike:(int)identifier forObjectType:(NSString *)type {
    NSString *key;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    key = [Crypto getKey];
    NSString *url = [NSString stringWithFormat:@"%@likes/destroy?user_id=%i&secureKey=%@&like[typeObj]=%@&like[obj_id]=%i", API_URL, user.identifier, key, type, identifier];
    NSDictionary *json = [Request getRequest:url];
    
    //NSLog(@"url : %@", url);
    
    NSLog(@"json DISLIKE : %@", json);
    
    if ([[json objectForKey:@"code"] integerValue] == 202) {
        return true;
    }
    
    return false;
}


@end
