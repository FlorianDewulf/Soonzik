//
//  LikesController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/11/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LikesController : NSObject

+ (BOOL)like:(int)identifier forObjectType:(NSString *)type;
+ (BOOL)dislike:(int)identifier forObjectType:(NSString *)type;

@end
