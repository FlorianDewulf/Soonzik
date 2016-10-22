//
//  Influence.m
//  SoonZik
//
//  Created by Maxime Sauvage on 11/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Influence.h"
#import "Genre.h"

@implementation Influence

- (id)initWithJsonObject:(NSDictionary *)json {
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.name = [json objectForKey:@"name"];
    self.listOfGenres = [[NSMutableArray alloc] init];
    NSArray *arr = [json objectForKey:@"genres"];
    for (NSDictionary *obj in arr) {
        Genre *genre = [[Genre alloc] initWithJsonObject:obj];
        [self.listOfGenres addObject:genre];
    }
    
    return self;
}

@end
