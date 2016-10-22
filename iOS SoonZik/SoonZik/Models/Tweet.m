//
//  Tweet.m
//  SoonZik
//
//  Created by Maxime Sauvage on 25/08/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithJsonObject:(NSDictionary *)json {
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.msg = [json objectForKey:@"msg"];
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateformat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:1];
    self.date = [dateformat dateFromString:[json objectForKey:@"created_at"]];
    self.user = [[User alloc] initWithJsonObject:[json objectForKey:@"user"]];
    
    return self;
}

@end
