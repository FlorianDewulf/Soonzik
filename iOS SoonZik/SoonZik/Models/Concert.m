//
//  Concert.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Concert.h"

@implementation Concert

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateformat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:1];
    self.date = [dateformat dateFromString:[json objectForKey:@"planification"]];
    self.url = [json objectForKey:@"url"];
    self.artist = [[User alloc] initWithJsonObject:[json objectForKey:@"user"]];
    self.address = [[Address alloc] initWithJsonObject:[json objectForKey:@"address"]];
    self.numberOfLikes = [[json objectForKey:@"likes"] integerValue];
    self.isLiked = [[json objectForKey:@"hasLiked"] boolValue];
    
    return self;
}

@end
