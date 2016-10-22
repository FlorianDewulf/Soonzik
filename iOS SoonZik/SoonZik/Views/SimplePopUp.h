//
//  SimplePopUp.h
//  SoonZik
//
//  Created by Maxime Sauvage on 15/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SimplePopUp : UIView

- (id)initWithMessage:(NSString *)message onView:(UIView *)view;
- (id)initWithMessage:(NSString *)message onView:(UIView *)view withSuccess:(BOOL)success;
- (void)show;

@property (nonatomic, assign) float popUpH;
@property (nonatomic, assign) float popUpW;
@property (nonatomic, assign) float screenH;
@property (nonatomic, assign) float screenW;
@property (nonatomic, assign) float finalYPos;

@property (nonatomic, strong) UIView *parentView;

@end
