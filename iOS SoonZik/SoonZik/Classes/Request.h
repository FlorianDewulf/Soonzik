//
//  Request.h
//  SoonZik
//
//  Created by Maxime Sauvage on 14/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request : NSObject <NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
}

+ (NSDictionary *)getRequest:(NSString *)url;
+ (NSDictionary *)postRequest:(NSString *)post url:(NSString *)url;

@end
