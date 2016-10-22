//
//  Translate.h
//  SoonZik
//
//  Created by Maxime Sauvage on 21/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Translate : NSObject

//+ (Translate *)sharedInstance:(NSString *)path;

@property (nonatomic, strong) NSDictionary *dict;

- (id)initWithPath:(NSString *)path;

@end
