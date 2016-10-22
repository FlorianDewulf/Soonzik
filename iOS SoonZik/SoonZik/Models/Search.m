//
//  Search.m
//  SoonZik
//
//  Created by Maxime Sauvage on 25/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Search.h"
#import "Request.h"
#import "User.h"
#import "Pack.h"
#import "Album.h"
#import "Music.h"

@implementation Search

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    self.listOfArtists = [[NSMutableArray alloc] init];
    self.listOfUsers = [[NSMutableArray alloc] init];
    self.listOfAlbums = [[NSMutableArray alloc] init];
    self.listOfMusics = [[NSMutableArray alloc] init];
    self.listOfPacks = [[NSMutableArray alloc] init];
    
    NSArray *albums = [json objectForKey:@"album"];
    for (NSDictionary *dict in albums) {
        [self.listOfAlbums addObject:[[Album alloc] initWithJsonObject:dict]];
    }
    NSArray *artists = [json objectForKey:@"artist"];
    for (NSDictionary *dict in artists) {
        [self.listOfArtists addObject:[[User alloc] initWithJsonObject:dict]];
    }
    NSArray *musics = [json objectForKey:@"music"];
    for (NSDictionary *dict in musics) {
        [self.listOfMusics addObject:[[Music alloc] initWithJsonObject:dict]];
    }
    NSArray *packs = [json objectForKey:@"pack"];
    for (NSDictionary *dict in packs) {
        [self.listOfPacks addObject:[[Pack alloc] initWithJsonObject:dict]];
    }
    NSArray *users = [json objectForKey:@"user"];
    for (NSDictionary *dict in users) {
        [self.listOfUsers addObject:[[User alloc] initWithJsonObject:dict]];
    }

    return self;
}

@end
