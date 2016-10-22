//
//  SocialConnect.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "User.h"

@interface SocialConnect : NSObject

+ (BOOL)shareOnFacebook:(id)elem onVC:(UIViewController *)vc;
+ (BOOL)shareOnTwitter:(id)elem onVC:(UIViewController *)vc;

@end
