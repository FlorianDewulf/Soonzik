//
//  RatingTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 04/09/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ValueChangedProtocol <NSObject>

- (void)valueChanged:(float)value;

@end

@interface RatingTableViewCell : UITableViewCell

- (void)initCell;

@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UIButton *btn;

@property (nonatomic, strong) IBOutlet UIImageView *star1;
@property (nonatomic, strong) IBOutlet UIImageView *star2;
@property (nonatomic, strong) IBOutlet UIImageView *star3;
@property (nonatomic, strong) IBOutlet UIImageView *star4;
@property (nonatomic, strong) IBOutlet UIImageView *star5;

@property (nonatomic, assign) int rating;

@property (nonatomic, strong) id<ValueChangedProtocol> delegate;

- (IBAction)rateSliderChanged:(UISlider *)slider;

@end
