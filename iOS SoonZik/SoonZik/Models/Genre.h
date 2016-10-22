//
//  Genre.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ObjectFactory.h"

@interface Genre : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSMutableArray *listOfMusics;

@end
