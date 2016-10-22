//
//  SimplePopUp.m
//  SoonZik
//
//  Created by Maxime Sauvage on 15/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "SimplePopUp.h"
#import "Tools.h"
#import "SVGKImage.h"

@implementation SimplePopUp

- (id)initWithMessage:(NSString *)message onView:(UIView *)view
{
    self = [super init];
    
    self.parentView = view;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.screenH = bounds.size.height;
    self.screenW = bounds.size.width;
    
    self.popUpH = 60;
    self.popUpW = self.screenW/1.5;
    
    self.finalYPos = [[UINavigationBar appearance]frame].size.height * 2 ;
    
    self.frame = CGRectMake((self.screenW-self.popUpW)/2, self.screenH/2-self.popUpH, self.popUpW, self.popUpH);
    self.alpha = 0;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.popUpW-20, 40)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 3;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth=YES;
    label.minimumScaleFactor=0.7;
    [self addSubview:label];
    
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(-10, 15);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    
    self.backgroundColor = DARK_GREY;
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(closePopUp) userInfo:nil repeats:false];
    
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
    [self.parentView addSubview:self];
}

- (void)closePopUp {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (id)initWithMessage:(NSString *)message onView:(UIView *)view withSuccess:(BOOL)success
{
    self = [super init];
    
    self.parentView = view;
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.screenH = bounds.size.height;
    self.screenW = bounds.size.width;
    
    self.popUpH = 100;
    self.popUpW = self.screenW/1.5;
    
    self.finalYPos = [[UINavigationBar appearance]frame].size.height * 2 ;
    
    self.frame = CGRectMake((self.screenW-self.popUpW)/2, self.screenH/2-self.popUpH, self.popUpW, self.popUpH);
    self.alpha = 0;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.popUpW-20, 40)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 3;
    label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth=YES;
    label.minimumScaleFactor=0.7;
    [self addSubview:label];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.popUpW/2-15, label.frame.size.height + 18, 30, 30)];
    if (success) {
        imgV.image = [Tools imageWithImage:[SVGKImage imageNamed:@"check_white"].UIImage scaledToSize:CGSizeMake(30, 30)];
    } else {
        imgV.image = [Tools imageWithImage:[SVGKImage imageNamed:@"delete_white"].UIImage scaledToSize:CGSizeMake(30, 30)];
    }
    
    [self addSubview:imgV];
    
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(-10, 15);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    
    self.backgroundColor = DARK_GREY;
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(closePopUp) userInfo:nil repeats:false];
    
    return self;
}


@end
