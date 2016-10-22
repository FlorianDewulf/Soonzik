//
//  Address.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Address.h"

@implementation Address

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.streetNbr = [json objectForKey:@"numberStreet"];
    self.street = [json objectForKey:@"street"];
    self.complement = [json objectForKey:@"complement"];
    self.city = [json objectForKey:@"city"];
    self.country = [json objectForKey:@"country"];
    self.zipCode = [json objectForKey:@"zipcode"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSString stringWithFormat:@"%i", self.identifier] forKey:@"identifier"];
    [aCoder encodeObject:self.streetNbr forKey:@"streetNbr"];
    [aCoder encodeObject:self.street forKey:@"street"];
    [aCoder encodeObject:self.complement forKey:@"firstname"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeObject:self.zipCode forKey:@"zipCode"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.lat] forKey:@"lat"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%f", self.lng] forKey:@"lng"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.identifier = [[aDecoder decodeObjectForKey:@"identifier"] integerValue];
        self.streetNbr = [aDecoder decodeObjectForKey:@"streetNbr"];
        self.street = [aDecoder decodeObjectForKey:@"street"];
        self.complement = [aDecoder decodeObjectForKey:@"complement"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.country = [aDecoder decodeObjectForKey:@"country"];
        self.zipCode = [aDecoder decodeObjectForKey:@"zipCode"];
    }
    return self;
}

@end
