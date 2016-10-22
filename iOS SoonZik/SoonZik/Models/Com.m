//
//  Com.m
//  SoonZik
//
//  Created by Maxime Sauvage on 20/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Com.h"

@implementation Com

- (id) initWithJsonObject:(NSDictionary *)json {
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.author = [Factory provideObjectWithClassName:@"User" andIdentifier:[[json objectForKey:@"author_id"] intValue]];
    self.content = [json objectForKey:@"content"];
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateformat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:1];
    self.date = [dateformat dateFromString:[json objectForKey:@"created_at"]];
    
    return self;
}

@end
