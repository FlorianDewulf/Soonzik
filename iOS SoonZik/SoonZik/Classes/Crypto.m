//
//  Crypto.m
//  SoonZik
//
//  Created by Maxime Sauvage on 14/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Crypto.h"
#import "User.h"
#import "Secu.h"

@implementation Crypto

+ (NSString *)getKey {
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];

    bool need = false;
    
    NSLog(@"user.secureKey : %@", [[Secu sharedInstance] secureKey]);
    if ([[Secu sharedInstance] secureKey] == nil) {
        need = true;
        NSLog(@"secure KEy is null");
    } else {
        NSDate *now = [[NSDate date] dateByAddingTimeInterval:1 * 60 * 60];
        NSLog(@"now : %@", now);
        NSLog(@"user.secureDate : %@", [[Secu sharedInstance] secureKeyDate]);
        
        if ([now compare:[[Secu sharedInstance] secureKeyDate]] == NSOrderedDescending) {
            need = true;
        }
    }
    /************/
    need = true;
    /************/
    
    if (need) {
        NSLog(@"NEED");
        NSString *url = [NSString stringWithFormat:@"%@getKey/%i", API_URL, user.identifier];
        NSDictionary *json = [Request getRequest:url];
        
        NSString *stringDate = [json objectForKey:@"last_update"];
        stringDate = [stringDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        stringDate = [stringDate stringByReplacingOccurrencesOfString:@"+00:00" withString:@""];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        NSDate *date = [dateFormat dateFromString:stringDate];
        date = [date dateByAddingTimeInterval:1 * 60 * 60];
        
        NSString *secureKey = [json objectForKey:@"key"];
        
        NSString *conca = [NSString stringWithFormat:@"%@%@", user.salt, secureKey];
        NSString *key = [Crypto sha256HashFor:conca];
        
        [Secu sharedInstance].secureKeyDate = date;
        [Secu sharedInstance].secureKey = key;
        
         NSLog(@"user.secureKey   AFTER : %@", [[Secu sharedInstance] secureKey]);
    } else {
        NSLog(@"NO NEED");
    }
    
    return [[Secu sharedInstance] secureKey];
}

+ (NSString*)sha256HashFor:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for (int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


@end
