//
//  Factory.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Factory.h"
#import "User.h"
#import "Playlist.h"

@implementation Factory

+ (id)provideObjectWithClassName:(NSString *)className andIdentifier:(int)identifier
{
    Class cl = NSClassFromString(className);
    
    Network *net = [[Network alloc] init];
    NSDictionary *json = [net getJsonWithClassName:className andIdentifier:identifier];
    
    json = [json objectForKey:@"content"];
    id elem = [[cl alloc] initWithJsonObject:json];
    
    return elem;
}

+ (NSArray *)provideListWithClassName:(NSString *)className
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    Class cl = NSClassFromString(className);
    
    Network *net = [[Network alloc] init];
    NSDictionary *json = [net getJsonWithClassName:className];
    json = [json objectForKey:@"content"];
    for (NSDictionary *dict in json) {
        id elem = [[cl alloc] initWithJsonObject:dict];
       [list addObject:elem];
    }
    
    return list;
}

+ (NSArray *)provideListWithClassName:(NSString *)className andIdentifier:(int)identifier
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    Class cl = NSClassFromString(className);
    
    Network *net = [[Network alloc] init];
    NSDictionary *json = [net getJsonWithClassName:className andIdentifier:identifier];
    
    json = [json objectForKey:@"content"];
    for (NSDictionary *dict in json) {
        id elem = [[cl alloc] initWithJsonObject:dict];
        [list addObject:elem];
    }
    
    return list;
}

+ (NSMutableArray *)findElementWithClassName:(NSString *)className andValues:(NSString *)values
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    Class cl = NSClassFromString(className);
    
    Network *net = [[Network alloc] init];
    NSDictionary *json = [net findJsonElementWithClassName:className andValues:values];
    
    json = [json objectForKey:@"content"];
    
    for (NSDictionary *dict in json) {
        id elem = [[cl alloc] initWithJsonObject:dict];
        [list addObject:elem];
    }
    
    return list;
}

@end
