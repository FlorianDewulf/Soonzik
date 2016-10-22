//
//  Language.h
//  SoonZik
//
//  Created by Maxime Sauvage on 03/09/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ObjectFactory.h"

@interface Language : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *abbreviation;
@property (nonatomic, strong) NSString *language;

@end
