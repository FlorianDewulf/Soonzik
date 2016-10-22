//
//  Cart.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Cart.h"
#import "Album.h"

@implementation Cart

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    self.albums = [[NSMutableArray alloc] init];
    self.musics = [[NSMutableArray alloc] init];
    
    NSArray *albums = [json objectForKey:@"albums"];
    NSArray *musics = [json objectForKey:@"musics"];
    self.identifier = [[json objectForKey:@"id"] intValue];
    if (albums.count != 0) {
        [self.albums addObject:[[Album alloc] initWithJsonObject:[albums firstObject]]];
        self.type = 1;
    } else if (musics.count != 0) {
        [self.musics addObject:[[Music alloc] initWithJsonObject:[musics firstObject]]];
        self.type = 2;
    }
    
    return self;
}

@end
