//
//  Cart.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ObjectFactory.h"

@interface Cart : ObjectFactory

@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong) NSMutableArray *musics;
@property (nonatomic, assign) int identifier;
@property (nonatomic, assign) int type;

@end
