//
//  PlaylistsController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "PlaylistsController.h"

@implementation PlaylistsController

+ (BOOL)deletePlaylist:(int)identifier {
    NSString *url, *key;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    key = [Crypto getKey];
    url = [NSString stringWithFormat:@"%@playlists/destroy?user_id=%i&secureKey=%@&id=%i", API_URL, user.identifier, key, identifier];
    
    NSDictionary *json = [Request getRequest:url];
    
    NSLog(@"json delete : %@", json);
    
    if ([[json objectForKey:@"code"] intValue] == 202) {
        return YES;
    }
    
    return NO;
}

+  (NSMutableArray *)getPlaylists {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@playlists/find?attribute[user_id]=%i", API_URL, user.identifier];
    
    NSLog(@"url : %@", url);
    
    NSDictionary *json = [Request getRequest:url];
    json = [json objectForKey:@"content"];
    
    NSLog(@"playlists : %@", json);
    
    for (NSDictionary *dict in json) {
        Playlist *p = [[Playlist alloc] initWithJsonObject:dict];
        [list addObject:p];
    }
    
    return list;
}

+ (Playlist *)createAPlaylist:(Playlist *)playlist {
    NSString *url, *post, *key;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *data = [prefs objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@playlists/save", API_URL];
    key = [Crypto getKey];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&playlist[user_id]=%i&playlist[name]=%@", user.identifier, key, user.identifier, playlist.title];
    
    NSDictionary *json = [Request postRequest:post url:url];
    
    NSLog(@"create playlist : %@", json);
    Playlist *p;
    if ([[json objectForKey:@"code"] intValue] != 503) {
        p = [[Playlist alloc] initWithJsonObject:[json objectForKey:@"content"]];
    } else {
        p = [[Playlist alloc] init];
        p.identifier = -1;
    }
    return p;
}

+ (BOOL)addToPlaylist:(Playlist *)playlist :(Music *)music {
    NSString *url, *post, *key;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@musics/addtoplaylist", API_URL];
    key = [Crypto getKey];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&id=%i&playlist_id=%i", user.identifier, key, music.identifier, playlist.identifier];
    
    NSDictionary *json = [Request postRequest:post url:url];
    
    if ([[json objectForKey:@"code"] intValue] == 201) {
        return true;
    }
    
    return false;
}

+ (BOOL)removeFromPlaylist:(Playlist *)playlist :(Music *)music {
    NSString *url, *key;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    key = [Crypto getKey];
    
    url = [NSString stringWithFormat:@"%@musics/delfromplaylist?user_id=%i&secureKey=%@&playlist_id=%i&id=%i", API_URL, user.identifier, key, playlist.identifier, music.identifier];
    
    NSDictionary *json = [Request getRequest:url];
    
    NSLog(@"json delete : %@", json);
    if ([[json objectForKey:@"code"] intValue] == 200) {
        return true;
    }
    
    return false;
}

@end
