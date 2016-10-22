//
//  ShareView.h
//  SoonZik
//
//  Created by Maxime Sauvage on 23/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CloseShareDelegate <NSObject>

- (void)closeView;

@end

@interface ShareView : UIView <UITextViewDelegate>

@property (nonatomic, strong) id<CloseShareDelegate> closeDelegate;
@property (nonatomic, assign) bool facebookbSharing;
@property (nonatomic, assign) bool twitterSharing;

@property (nonatomic, strong) UIButton *facebookButton;
@property (nonatomic, strong) UIButton *twitterButton;

- (id)initWithElement:(id)elem onView:(UIView *)view;


@end
