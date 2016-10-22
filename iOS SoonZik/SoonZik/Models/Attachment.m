//
//  Attachment.m
//  SoonZik
//
//  Created by Maxime Sauvage on 12/09/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Attachment.h"

@implementation Attachment

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.url = [json objectForKey:@"url"];
    self.contentType = [json objectForKey:@"content_type"];
    
    return self;
}

@end
