//
//  UserListen.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ObjectFactory.h"
#import "User.h"
#import "Music.h"

@interface UserListen : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Music *music;
@property (nonatomic, strong) User *artist;
@property (nonatomic, assign) float lat;
@property (nonatomic, assign) float lng;
@property (nonatomic, strong) NSDate *date;

@end
