//
//  Translate.m
//  SoonZik
//
//  Created by Maxime Sauvage on 21/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Translate.h"

@implementation Translate

- (id)initWithPath:(NSString *)path {
    self = [super init];
    self.dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.dict forKey:@"dict"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.dict = [aDecoder decodeObjectForKey:@"dict"];
    }
    return self;
}


@end
