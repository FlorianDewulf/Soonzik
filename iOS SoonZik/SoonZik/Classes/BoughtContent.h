//
//  BoughtContent.h
//  SoonZik
//
//  Created by Maxime Sauvage on 26/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ObjectFactory.h"

@interface BoughtContent : ObjectFactory

@property (nonatomic, strong) NSMutableArray *listOfMusics;
@property (nonatomic, strong) NSMutableArray *listOfAlbums;
@property (nonatomic, strong) NSMutableArray *listOfPacks;

@end
