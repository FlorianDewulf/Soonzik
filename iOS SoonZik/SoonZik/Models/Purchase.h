//
//  Purchase.h
//  SoonZik
//
//  Created by Maxime Sauvage on 11/08/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ObjectFactory.h"

@interface Purchase : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSMutableArray *listOfMusics;
@property (nonatomic, strong) NSMutableArray *listOfAlbums;
@property (nonatomic, strong) NSMutableArray *listOfPacks;

@end
