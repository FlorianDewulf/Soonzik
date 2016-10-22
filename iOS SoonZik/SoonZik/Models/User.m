//
//  User.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "User.h"

@implementation User

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.email = [json objectForKey:@"email"];
    self.username = [json objectForKey:@"username"];
    self.firstname = [json objectForKey:@"fname"];
    self.lastname = [json objectForKey:@"lname"];
    self.birthday = [json objectForKey:@"birthday"];
    self.image = [json objectForKey:@"image"];
    if ([[json objectForKey:@"description"] isEqual:nil]) {
        self.desc = @"";
    } else {
        self.desc = [json objectForKey:@"description"];
    }
    self.salt = [json objectForKey:@"salt"];
    self.friends = [[NSMutableArray alloc] init];
    NSArray *friends = [json objectForKey:@"friends"];
    for (NSDictionary *dict in friends) {
        [self.friends addObject:[self getFriend:dict]];
    }
    
    self.address = [[Address alloc] initWithJsonObject:[json objectForKey:@"address"]];
    
    return self;
}

- (User *)getFriend:(NSDictionary *)json {
    User *friend = [[User alloc] initWithJsonObject:json];
    return friend;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSString stringWithFormat:@"%i", self.identifier] forKey:@"identifier"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.firstname forKey:@"firstname"];
    [aCoder encodeObject:self.lastname forKey:@"lastname"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeObject:self.salt forKey:@"salt"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.follows forKey:@"follows"];
    [aCoder encodeObject:self.followers forKey:@"followers"];
    [aCoder encodeObject:self.friends forKey:@"friends"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.identifier = [[aDecoder decodeObjectForKey:@"identifier"] integerValue];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.firstname = [aDecoder decodeObjectForKey:@"firstname"];
        self.lastname = [aDecoder decodeObjectForKey:@"lastname"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.image = [aDecoder decodeObjectForKey:@"image"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.salt = [aDecoder decodeObjectForKey:@"salt"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.follows = [aDecoder decodeObjectForKey:@"follows"];
        self.followers = [aDecoder decodeObjectForKey:@"followers"];
        self.friends = [aDecoder decodeObjectForKey:@"friends"];
    }
    return self;
}

@end
