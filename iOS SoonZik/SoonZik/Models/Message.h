//
//  Message.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ObjectFactory.h"
#import "User.h"
#import "SOMessage.h"

@interface Message : ObjectFactory <SOMessage>

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) User *fromUser;
@property (nonatomic, strong) NSString *fromUsername;
@property (nonatomic, strong) User *toUser;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) BOOL fromMe;
@property (nonatomic, strong) NSString *text;
@property (strong, nonatomic) NSDictionary *attributes;
@property (strong, nonatomic) NSData *media;
@property (strong, nonatomic) UIImage *thumbnail;
@property (nonatomic) SOMessageType type;

- (id)initWithSocket:(NSString *)sock;

@end
