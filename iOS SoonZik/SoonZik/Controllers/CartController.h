//
//  CartController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 08/08/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cart.h"

@interface CartController : NSObject

+ (NSMutableArray *)getCart;
+ (Cart *)addToCart:(NSString *)type :(int)objId;
+ (BOOL)removeCart:(int)cartId;
+ (NSMutableArray *)giftCart:(int)cartId forUser:(int)userId;
+ (BOOL)buyCart:(NSString *)paypalId;

@end
