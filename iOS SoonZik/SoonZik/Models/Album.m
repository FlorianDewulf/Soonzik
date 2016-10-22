//
//  Album.m
//  SoonZik
//
//  Created by LLC on 04/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Album.h"

@implementation Album

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
   //NSLog(@"json album : %@", json);
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.image = [json objectForKey:@"image"];
    self.price = [[json objectForKey:@"price"] floatValue];
    self.title = [json objectForKey:@"title"];
    if ([json objectForKey:@"user"]) {
        self.artist = [[User alloc] initWithJsonObject:[json objectForKey:@"user"]];
    }
    self.listOfMusics = [[NSMutableArray alloc] init];
    NSDictionary *musics = [json objectForKey:@"musics"];
    
    if (musics != nil) {
        int i = 0;
        for (NSDictionary *music in musics) {
            Music *m = [[Music alloc] initWithJsonObject:music];
            m.albumImage = self.image;
            [self.listOfMusics addObject:m];
            i++;
        }
    }
    
    self.numberOfLikes = [[json objectForKey:@"likes"] integerValue];
    self.isLiked = [[json objectForKey:@"hasLiked"] boolValue];
    
    return self;
}

@end
