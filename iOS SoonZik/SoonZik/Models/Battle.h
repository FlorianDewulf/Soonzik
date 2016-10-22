//
//  Battle.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ObjectFactory.h"
#import "User.h"

@interface Battle : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) User *artistOne;
@property (nonatomic, strong) User *artistTwo;
@property (nonatomic, strong) NSDate *beginDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign) int voteArtistOne;
@property (nonatomic, assign) int voteArtistTwo;

@end
