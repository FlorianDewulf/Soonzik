//
//  News.h
//  SoonZik
//
//  Created by LLC on 08/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Attachment.h"
#import "Comment.h"
#import "ObjectFactory.h"

@interface News : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *listOfContents;
@property (nonatomic, strong) User *author;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSMutableArray *listOfAttachments;
@property (nonatomic, strong) NSMutableArray *listOfComments;
@property (nonatomic, strong) NSMutableArray *listOfNewsTexts;
@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, assign) int numberOfLikes;

@end
