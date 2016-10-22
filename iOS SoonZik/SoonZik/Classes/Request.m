//
//  Request.m
//  SoonZik
//
//  Created by Maxime Sauvage on 14/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "Request.h"

@implementation Request

+ (NSDictionary *)getRequest:(NSString *)url {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString* encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"url : %@", encodedUrl);
    [request setURL:[NSURL URLWithString:encodedUrl]];
    [request setHTTPMethod:@"GET"];
    //[request setValue:@"" forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLResponse *response;
    NSError *error;

    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
   
    if (error) {
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    }
    
    return results;
}

+ (NSDictionary *)postRequest:(NSString *)post url:(NSString *)url {
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString* encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"url : %@ /!\ post : %@", encodedUrl, post);
    [request setURL:[NSURL URLWithString:encodedUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLResponse *response;
    NSError *error;
    NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) {
        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    }
    
    //NSLog(@"result : %@", results);
    
    return results;
}

@end
