//
//  Ambiance.m
//  SoonZik
//
//  Created by Maxime Sauvage on 09/01/16.
//  Copyright © 2016 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Ambiance.h"

@implementation Ambiance

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.name = [json objectForKey:@"name"];
        
    return self;
}


@end
