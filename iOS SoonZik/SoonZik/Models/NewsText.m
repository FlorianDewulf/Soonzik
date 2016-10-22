//
//  NewsText.m
//  SoonZik
//
//  Created by Maxime Sauvage on 19/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "NewsText.h"

@implementation NewsText

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.content = [json objectForKey:@"content"];
    self.title = [json objectForKey:@"title"];
    
    return self;
}

@end
