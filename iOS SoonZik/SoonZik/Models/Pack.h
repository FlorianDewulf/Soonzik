//
//  Pack.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Element.h"
#import "Genre.h"
#import "Album.h"
#import "Comment.h"

@interface Pack : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) float price;
@property (nonatomic, assign) float avgPrice;
@property (nonatomic, strong) NSMutableArray *listOfAlbums;
@property (nonatomic, strong) NSMutableArray *listOfComments;
@property (nonatomic, strong) NSMutableArray *listOfDescriptions;
@property (nonatomic, strong) NSMutableArray *partialAlbums;

+ (Pack *)getPack:(int)packID;

@end
