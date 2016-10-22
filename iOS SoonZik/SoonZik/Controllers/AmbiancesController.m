//
//  AmbiancesController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 09/01/16.
//  Copyright © 2016 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "AmbiancesController.h"
#import "Request.h"
#import "Ambiance.h"
#import "Music.h"

@implementation AmbiancesController

+ (NSMutableArray *)getAmbiances {
    NSString *url = [NSString stringWithFormat:@"%@ambiances", API_URL];
    NSDictionary *json = [Request getRequest:url];
    //NSLog(@"json ambiances: %@", json);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in [json objectForKey:@"content"]) {
        [array addObject:[[Ambiance alloc] initWithJsonObject:dic]];
    }
    
    return array;
}

+ (NSMutableArray *)getAmbiance:(int)identifier {
    NSString *url = [NSString stringWithFormat:@"%@ambiances/%i", API_URL, identifier];
    NSDictionary *json = [Request getRequest:url];
   // NSLog(@"json ambiances %i: %@", identifier, json);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([[json objectForKey:@"code"] integerValue] == 200) {
        NSDictionary *content = [json objectForKey:@"content"];
        for (NSDictionary *dic in [content objectForKey:@"musics"]) {
            [array addObject:[[Music alloc] initWithJsonObject:dic]];
        }
    }
    
    return array;
}

@end
