//
//  Concert.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ObjectFactory.h"
#import "Address.h"
#import "User.h"

@interface Concert : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) User *artist;
@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, assign) int numberOfLikes;

@end
