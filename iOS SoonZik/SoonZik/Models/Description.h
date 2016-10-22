//
//  Description.h
//  SoonZik
//
//  Created by Maxime Sauvage on 27/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ObjectFactory.h"

@interface Description : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *language;

@end
