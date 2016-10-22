//
//  UserListen.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "UserListen.h"

@implementation UserListen

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] integerValue];
    self.lat = [[json objectForKey:@"latitude"] floatValue];
    self.lng = [[json objectForKey:@"longitude"] floatValue];
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    self.date = [dateformat dateFromString:[json objectForKey:@"created_at"]];
    
    self.user = [[User alloc] initWithJsonObject:[json objectForKey:@"user"]];
    self.music = [[Music alloc] initWithJsonObject:[json objectForKey:@"music"]];
    
    return self;
}

@end
