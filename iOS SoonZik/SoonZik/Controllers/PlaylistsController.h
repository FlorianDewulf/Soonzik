//
//  PlaylistsController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Playlist.h"
#import "Music.h"

@interface PlaylistsController : NSObject

+ (BOOL)deletePlaylist:(int)identifier;
+ (NSMutableArray *)getPlaylists;
+ (Playlist *)createAPlaylist:(Playlist *)playlist;
+ (BOOL)addToPlaylist:(Playlist *)playlist :(Music *)music;
+ (BOOL)removeFromPlaylist:(Playlist *)playlist :(Music *)music;

@end
