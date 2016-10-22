//
//  SearchsController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "SearchsController.h"

@implementation SearchsController

+ (Search *)getSearchResults:(NSString *)word {
    NSDictionary *json = [Request getRequest:[NSString stringWithFormat:@"%@search?query=%@", API_URL, word]];
    if (![[json objectForKey:@"message"] isEqualToString:@"NoContent"]) {
        return [[Search alloc] initWithJsonObject:[json objectForKey:@"content"]];
    }
    return [[Search alloc] init];
}

@end
