//
//  Tweet.h
//  SoonZik
//
//  Created by Maxime Sauvage on 25/08/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ObjectFactory.h"
#import "User.h"

@interface Tweet : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSDate *date;

@end
