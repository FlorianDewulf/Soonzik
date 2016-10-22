//
//  Network.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Network.h"
#import "Playlist.h"
#import "User.h"
#import "Crypto.h"

@implementation Network

- (NSDictionary *) getJsonWithClassName:className
{
    NSString *url = nil;
    
    if ([className isEqualToString:@"User"]) {
        url = [NSString stringWithFormat:@"%@users", API_URL];
    } else if ([className isEqualToString:@"Pack"]) {
        url = [NSString stringWithFormat:@"%@packs", API_URL];
    } else if ([className isEqualToString:@"Music"]) {
        url = [NSString stringWithFormat:@"%@musics", API_URL];
    } else if ([className isEqualToString:@"Album"]) {
        url = [NSString stringWithFormat:@"%@albums", API_URL];
    } else if ([className isEqualToString:@"News"]) {
        url = [NSString stringWithFormat:@"%@news", API_URL];
    } else if ([className isEqualToString:@"Genre"]) {
        url = [NSString stringWithFormat:@"%@genres", API_URL];
    } else if ([className isEqualToString:@"Influence"]) {
        url = [NSString stringWithFormat:@"%@influences", API_URL];
    }
    
    NSLog(@"url get json with name : %@", url);
    
    return [Request getRequest:url];
}

- (NSDictionary *) getJsonWithClassName:className andIdentifier:(int)identifier
{
    NSString *url = nil;
    
    NSString *key;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    key = [Crypto getKey];

    
    if ([className isEqualToString:@"User"]) {
        url = [NSString stringWithFormat:@"%@users/%i", API_URL, identifier];
    } else if ([className isEqualToString:@"Pack"]) {
        url = [NSString stringWithFormat:@"%@packs/%i", API_URL, identifier];
    } else if ([className isEqualToString:@"Music"]) {
        url = [NSString stringWithFormat:@"%@musics/%i", API_URL, identifier];
    } else if ([className isEqualToString:@"Album"]) {
        url = [NSString stringWithFormat:@"%@albums/%i?user_id=%i&secureKey=%@", API_URL, identifier, user.identifier, key];
    } else if ([className isEqualToString:@"News"]) {
        url = [NSString stringWithFormat:@"%@news/%i?user_id=%i&secureKey=%@", API_URL, identifier, user.identifier, key];
    } else if ([className isEqualToString:@"Genre"]) {
        url = [NSString stringWithFormat:@"%@genres/%i", API_URL, identifier];
    }
    
    NSLog(@"url get json with name : %@", url);
    
    return [Request getRequest:url];
}

- (NSDictionary *) findJsonElementWithClassName:className andValues:(NSString *)values
{
    NSString *url = nil;
    
    if ([className isEqualToString:@"User"]) {
        url = [NSString stringWithFormat:@"%@users/find?%@", API_URL, values];
    } else if ([className isEqualToString:@"Album"]) {
        url = [NSString stringWithFormat:@"%@albums/find?%@", API_URL, values];
    } else if ([className isEqualToString:@"Music"]) {
        url = [NSString stringWithFormat:@"%@musics/find?%@", API_URL, values];
    } else if ([className isEqualToString:@"Battle"]) {
        url = [NSString stringWithFormat:@"%@battles/find?%@", API_URL, values];
    }
    
    return [Request getRequest:url];
}

@end
