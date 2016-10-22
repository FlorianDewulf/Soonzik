//
//  Genre.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Genre.h"
#import "Music.h"

@implementation Genre

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.name = [json objectForKey:@"style_name"];
    self.color = [json objectForKey:@"color_hexa"];
    self.listOfMusics = [[NSMutableArray alloc] init];
    NSDictionary *listOfMusics = [json objectForKey:@"musics"];
    for (NSDictionary *dict in listOfMusics) {
        [self.listOfMusics addObject:[[Music alloc] initWithJsonObject:dict]];
    }
    
    return self;
}

@end
