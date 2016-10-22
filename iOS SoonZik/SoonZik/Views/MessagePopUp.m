//
//  MessagePopUp.m
//  SoonZik
//
//  Created by Maxime Sauvage on 03/10/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "MessagePopUp.h"

@implementation MessagePopUp

- (void)initView
{
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    
    self.usernameLabel.textColor = [UIColor whiteColor];
    self.usernameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
    self.usernameLabel.textAlignment = NSTextAlignmentLeft;
    
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(-10, 15);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    
    self.backgroundColor = DARK_GREY;
    
    self.center = CGPointMake([self superview].bounds.size.width/2, 40);
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(closePopUp) userInfo:nil repeats:false];
}

- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}

- (void)closePopUp {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
