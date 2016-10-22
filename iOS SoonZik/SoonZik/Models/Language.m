//
//  Language.m
//  SoonZik
//
//  Created by Maxime Sauvage on 03/09/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Language.h"

@implementation Language

- (id)initWithJsonObject:(NSDictionary *)json {
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.abbreviation = [json objectForKey:@"abbreviation"];
    self.language = [json objectForKey:@"language"];
    
    return self;
}

@end
