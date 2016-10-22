//
//  TopMusic.h
//  SoonZik
//
//  Created by Maxime Sauvage on 21/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ObjectFactory.h"
#import "Music.h"
#import "User.h"

@interface TopMusic : ObjectFactory

@property (nonatomic, assign) float note;
@property (nonatomic, strong) Music *music;

@end
