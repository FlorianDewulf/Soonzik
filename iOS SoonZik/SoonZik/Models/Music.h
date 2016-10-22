//
//  Music.h
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ObjectFactory.h"
#import "Genre.h"
#import "User.h"
#import "Comment.h"
#import "Album.h"
#import "Playlist.h"
#import "Request.h"

@interface Music : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) int duration;
@property (nonatomic, strong) Genre *genre;
@property (nonatomic, assign) float price;
@property (nonatomic, strong) User *artist;
@property (nonatomic, strong) NSString *albumImage;
@property (nonatomic, assign) int albumId;
@property (nonatomic, assign) int isLimited;

@end
