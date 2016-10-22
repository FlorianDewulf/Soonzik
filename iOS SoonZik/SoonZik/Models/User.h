//
//  User.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ObjectFactory.h"
#import "Address.h"
#import "Factory.h"

@interface User : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) NSString *salt;
@property (nonatomic, strong) NSArray *follows;
@property (nonatomic, strong) NSMutableArray *followers;
@property (nonatomic, strong) NSMutableArray *friends;

@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *language;

@end
