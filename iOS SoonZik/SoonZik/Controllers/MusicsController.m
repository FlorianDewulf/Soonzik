//
//  MusicsController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "MusicsController.h"

@implementation MusicsController

+ (TopMusic *)getBestMusicOfArtist:(User *)artist
{
    NSString *url = [NSString stringWithFormat:@"%@users/%i/isartist", API_URL, artist.identifier];
    NSDictionary *json = [Request getRequest:url];
    
    NSDictionary *jsonData = [json objectForKey:@"content"];
    
    NSArray *listOfTopMusics = [jsonData objectForKey:@"topFive"];
    NSDictionary *musicElement = [listOfTopMusics firstObject];
    TopMusic *top = [[TopMusic alloc] initWithJsonObject:musicElement];
    
    return top;
}

+ (BOOL)rateMusic:(Music *)music :(int)rate {
    NSString *url, *post, *key;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@musics/%i/note/%i", API_URL, music.identifier, rate];
    key = [Crypto getKey];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@", user.identifier, key];
    
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"json rate : %@", json);
    if ([[json objectForKey:@"code"] intValue] == 201) {
        return true;
    }
    return false;
}

@end
