//
//  Music.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Music.h"

@implementation Music

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];

    self.identifier = [[json objectForKey:@"id"] intValue];
    self.title = [json objectForKey:@"title"];
    self.duration = [[json objectForKey:@"duration"] intValue];
    self.price = [[json objectForKey:@"price"] floatValue];
    NSDictionary *album = [json objectForKey:@"album"];
    self.albumImage = [album objectForKey:@"image"];
    self.albumId = [[album objectForKey:@"id"] intValue];
    self.artist = [[User alloc] initWithJsonObject:[json objectForKey:@"user"]];
    
    return self;
}

@end
