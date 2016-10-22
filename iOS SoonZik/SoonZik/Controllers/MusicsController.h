//
//  MusicsController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopMusic.h"
#import "User.h"

@interface MusicsController : NSObject

+ (TopMusic *)getBestMusicOfArtist:(User *)artist;
+ (BOOL)rateMusic:(Music *)music :(int)rate;

@end
