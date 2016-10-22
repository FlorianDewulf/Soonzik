//
//  ObjectFactory.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/12/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Network.h"

@interface ObjectFactory : NSObject

- (id)initWithJsonObject:(NSDictionary *)json;

@end
