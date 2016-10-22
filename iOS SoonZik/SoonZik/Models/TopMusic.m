//
//  TopMusic.m
//  SoonZik
//
//  Created by Maxime Sauvage on 21/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TopMusic.h"

@implementation TopMusic

- (id)initWithJsonObject:(NSDictionary *)json {
    self = [super init];
    
    self.note = [[json objectForKey:@"note"] floatValue];
    self.music = [[Music alloc] initWithJsonObject:[json objectForKey:@"music"]];
    
    return self;
}




@end
