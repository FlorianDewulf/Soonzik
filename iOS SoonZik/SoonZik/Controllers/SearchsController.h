//
//  SearchsController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Search.h"

@interface SearchsController : NSObject

+ (Search *)getSearchResults:(NSString *)word;

@end
