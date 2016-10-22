//
//  HeaderUserView.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderUserView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *userLabel;
@property (nonatomic, strong) IBOutlet UILabel *followersLabel;
@property (nonatomic, strong) IBOutlet UILabel *followsLabel;
@property (nonatomic, strong) IBOutlet UILabel *friendsLabel;
@property (nonatomic, strong) IBOutlet UIButton *friendButton;
@property (nonatomic, strong) IBOutlet UIButton *followButton;

- (void)initHeader;

@end
