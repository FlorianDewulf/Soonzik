//
//  Secu.m
//  SoonZik
//
//  Created by Maxime Sauvage on 21/11/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Secu.h"

@implementation Secu

static Secu *sharedInstance = nil;    // static instance variable

+ (Secu *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[Secu alloc] init];
    }
    return sharedInstance;
}

- (id)init {
    self = [super init];
    
    
    
    return self;
}

@end
