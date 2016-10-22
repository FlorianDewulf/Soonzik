//
//  AmbiancesController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/01/16.
//  Copyright © 2016 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmbiancesController : NSObject

+ (NSMutableArray *)getAmbiances;
+ (NSMutableArray *)getAmbiance:(int)identifier;

@end
