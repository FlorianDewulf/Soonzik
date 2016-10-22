//
//  SuggestsController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 25/08/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuggestsController : NSObject

+ (NSMutableArray *)getSuggests:(NSString *)type;

@end
