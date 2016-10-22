//
//  Ambiance.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/01/16.
//  Copyright © 2016 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ambiance : NSObject

@property (nonatomic, assign) int identifier;
@property (nonatomic, strong) NSString *name;

- (id)initWithJsonObject:(NSDictionary *)json;

@end
