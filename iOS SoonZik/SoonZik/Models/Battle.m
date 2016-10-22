//
//  Battle.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Battle.h"

@implementation Battle

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.artistOne = [[User alloc] initWithJsonObject:[json objectForKey:@"artist_one"]];
    self.artistTwo = [[User alloc] initWithJsonObject:[json objectForKey:@"artist_two"]];
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    self.beginDate = [dateformat dateFromString:[json objectForKey:@"date_begin"]];
    self.endDate = [dateformat dateFromString:[json objectForKey:@"date_end"]];
    
    self.title = [NSString stringWithFormat:@"%@ - %@", self.artistOne.username, self.artistTwo.username];
    NSArray *votes = [json objectForKey:@"votes"];
    self.voteArtistOne = 0;
    self.voteArtistTwo = 0;
    for (int i=0; i<votes.count; i++) {
        NSDictionary *vote = [votes objectAtIndex:i];
        if ([[vote objectForKey:@"artist_id"] intValue] == self.artistOne.identifier) {
            self.voteArtistOne += 1;
        } else if ([[vote objectForKey:@"artist_id"] intValue] == self.artistTwo.identifier) {
            self.voteArtistTwo += 1;
        }
    }
    
    return self;
}

@end
