//
//  FeedbackController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 09/01/16.
//  Copyright © 2016 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "FeedbackController.h"
#import "Crypto.h"
#import "User.h"

@implementation FeedbackController

+ (BOOL)sendFeedback:(NSString *)type object:(NSString *)object text:(NSString *)text {
    NSString *url, *key, *post;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    url = [NSString stringWithFormat:@"%@feedbacks/save", API_URL];
    //key = [Crypto getKey];
    post = [NSString stringWithFormat:@"feedback[email]=%@&feedback[type_object]=%@&feedback[object]=%@&feedback[text]=%@", user.email, type, object, text];
    
    NSDictionary *json = [Request postRequest:post url:url];
    NSLog(@"json FEEDBACK : %@", json);
    
    if ([[json objectForKey:@"code"] integerValue] == 201) {
        return true;
    }
    
    return false;
}


@end
