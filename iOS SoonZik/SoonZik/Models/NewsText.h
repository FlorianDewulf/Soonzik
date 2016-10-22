//
//  NewsText.h
//  SoonZik
//
//  Created by Maxime Sauvage on 19/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ObjectFactory.h"

@interface NewsText : ObjectFactory

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *title;

@end
