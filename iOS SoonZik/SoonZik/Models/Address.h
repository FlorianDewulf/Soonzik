//
//  Address.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ObjectFactory.h"

@interface Address : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *streetNbr;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *complement;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;

@end
