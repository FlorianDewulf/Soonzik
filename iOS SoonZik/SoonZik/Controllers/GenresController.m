//
//  GenresController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "GenresController.h"

@implementation GenresController

+ (Genre *)getGenre:(int)genreID {
    NSString *url = [NSString stringWithFormat:@"%@genres/%i", API_URL, genreID];
    NSDictionary *json = [Request getRequest:url];
    NSDictionary *content = [json objectForKey:@"content"];
    
    if (content.count == 0) {
        return [[Genre alloc] init];
    }
    Genre *genre = [[Genre alloc] initWithJsonObject:content];
    return genre;
}

@end
