//
//  MusicOptionsButton.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/12/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Music.h"
#import "Playlist.h"

@interface MusicOptionsButton : UIButton

@property (strong, nonatomic) Music *music;
@property (strong, nonatomic) Playlist *playlist;

@end
