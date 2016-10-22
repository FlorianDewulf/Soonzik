//
//  IdenticationsController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 03/09/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Language.h"

@interface IdenticationsController : NSObject

+ (User *)emailConnect:(NSString *)email andPassword:(NSString *)password;

+ (User *)facebookConnect:(NSString *)token email:(NSString *)email uid:(NSString *)uid;
+ (User *)twitterConnect:(NSString *)token uid:(NSString *)uid;
+ (User *)googleConnect:(NSString *)token uid:(NSString *)uid;

+ (User *)subscribe:(User *)user;

+ (NSMutableArray *)getLanguages;

@end
