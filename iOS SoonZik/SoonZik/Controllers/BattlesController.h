//
//  BattlesController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Battle.h"

@interface BattlesController : NSObject

+ (NSMutableArray *)getAllTheBattles;
+ (Battle *)getBattle:(int)battleID;
+ (Battle *)vote:(int)battleID :(int)artistID;

@end
