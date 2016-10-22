//
//  PacksController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pack.h"
#import "PayPalMobile.h"

@interface PacksController : NSObject

+ (Pack *)getPack:(int)packID;
+ (BOOL)buyPack:(int)packID amount:(float)amount artist:(float)artist association:(float)association website:(float)website withPayPalInfos:(PayPalPayment *)paymentInfos;
+ (BOOL)buyPack:(int)packID amount:(float)amount artist:(float)artist association:(float)association website:(float)website friendID:(int)friendID withPayPalInfos:(PayPalPayment *) paymentInfos;

@end
