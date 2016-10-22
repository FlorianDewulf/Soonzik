//
//  Secu.h
//  SoonZik
//
//  Created by Maxime Sauvage on 21/11/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Secu : NSObject

+ (Secu *)sharedInstance;

@property (nonatomic, strong) NSDate *secureKeyDate;
@property (nonatomic, strong) NSString *secureKey;

@end
