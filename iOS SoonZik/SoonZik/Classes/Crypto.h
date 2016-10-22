//
//  Crypto.h
//  SoonZik
//
//  Created by Maxime Sauvage on 14/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>
#import "Request.h"

@interface Crypto : NSObject

+ (NSString *)getKey;
+ (NSString*)sha256HashFor:(NSString*)input;

@end
