//
//  Album.h
//  SoonZik
//
//  Created by LLC on 04/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ObjectFactory.h"
#import "User.h"
#import "Music.h"

@interface Album : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) User *artist;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSMutableArray *listOfMusics;
@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, assign) int numberOfLikes;

@end
