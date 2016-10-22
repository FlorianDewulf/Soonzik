//
//  Influence.h
//  SoonZik
//
//  Created by Maxime Sauvage on 11/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ObjectFactory.h"

@interface Influence : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *listOfGenres;

@end
