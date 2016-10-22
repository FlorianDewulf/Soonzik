//
//  Description.m
//  SoonZik
//
//  Created by Maxime Sauvage on 27/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Description.h"

@implementation Description

- (id) initWithJsonObject:(NSDictionary *)json {
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.text = [json objectForKey:@"description"];
    self.language = [json objectForKey:@"language"];
    
    return self;
}

@end
