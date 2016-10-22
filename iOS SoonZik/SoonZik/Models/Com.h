//
//  Com.h
//  SoonZik
//
//  Created by Maxime Sauvage on 20/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ObjectFactory.h"
#import "User.h"
#import "News.h"

@interface Com : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) User *author;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *date;

@end
