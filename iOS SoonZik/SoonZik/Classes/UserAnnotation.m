//
//  UserAnnotation.m
//  SoonZik
//
//  Created by LLC on 30/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "UserAnnotation.h"

@implementation UserAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord user:(User *)user music:(Music *)music artist:(User *)artist
{
    self = [super init];
    if (self) {
        self.user = user;
        self.music = music;
        self.artist = artist;
        self.coordinate = coord;
    }
    
    return self;
}

@end
