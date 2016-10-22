//
//  News.m
//  SoonZik
//
//  Created by LLC on 08/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "News.h"
#import "Attachment.h"
#import "NewsText.h"

@implementation News

- (id)initWithJsonObject:(NSDictionary *)json
{
    self = [super init];
    self.identifier = [[json objectForKey:@"id"] intValue];
    self.title = [json objectForKey:@"title"];
    self.type = [json objectForKey:@"news_type"];
    self.content = [json objectForKey:@"content"];
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateformat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:1];
    
    self.listOfAttachments = [[NSMutableArray alloc] init];
    if ([[json objectForKey:@"attachments"] count] > 0) {
        for (NSDictionary *dict in [json objectForKey:@"attachments"]) {
            Attachment *atta = [[Attachment alloc] initWithJsonObject:dict];
            [self.listOfAttachments addObject:atta];
        }
    }
    
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *lang;
    if ([language isEqualToString:@"en"]) {
        lang = @"EN";
    } else if ([language isEqualToString:@"fr"]) {
        lang = @"FR";
    }
    
    self.listOfNewsTexts = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in [json objectForKey:@"newstexts"]) {
        if ([lang isEqualToString:[dict objectForKey:@"language"]]) {
            NewsText *newsText = [[NewsText alloc] initWithJsonObject:dict];
            [self.listOfNewsTexts addObject:newsText];
        }
    }
    
    self.numberOfLikes = [[json objectForKey:@"likes"] integerValue];
    self.isLiked = [[json objectForKey:@"hasLiked"] boolValue];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSString stringWithFormat:@"%i", self.identifier] forKey:@"identifier"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.listOfContents forKey:@"listOfContents"];
    [aCoder encodeObject:self.author forKey:@"author"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.listOfAttachments forKey:@"listOfAttachments"];
    [aCoder encodeObject:self.listOfNewsTexts forKey:@"listOfNewsTexts"];
    [aCoder encodeObject:self.listOfComments forKey:@"listOfComments"];
    [aCoder encodeObject:self.content forKey:@"content"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.identifier = [[aDecoder decodeObjectForKey:@"identifier"] intValue];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.listOfComments = [aDecoder decodeObjectForKey:@"listOfComments"];
        self.author = [aDecoder decodeObjectForKey:@"author"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.listOfAttachments = [aDecoder decodeObjectForKey:@"listOfAttachments"];
        self.listOfNewsTexts = [aDecoder decodeObjectForKey:@"listOfNewsTexts"];
        self.listOfComments = [aDecoder decodeObjectForKey:@"listOfComments"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
    }
    return self;
}

@end
