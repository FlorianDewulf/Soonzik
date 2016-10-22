//
//  ConcertsController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 01/09/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ConcertsController.h"
#import "User.h"
#import "Crypto.h"
#import "Request.h"
#import "Concert.h"

@implementation ConcertsController

+ (NSMutableArray *)getConcerts {
    NSString *url;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    url = [NSString stringWithFormat:@"%@concerts", API_URL];
    NSDictionary *json = [Request getRequest:url];
    if ([[json objectForKey:@"code"] intValue] == 200) {
        for (NSDictionary *dict in [json objectForKey:@"content"]) {
            [arr addObject:[[Concert alloc] initWithJsonObject:dict]];
        }
    }
    
    return arr;
}

@end
