//
//  RatingTableViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 04/09/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "RatingTableViewCell.h"

@implementation RatingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCell {
    self.btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btn.layer.borderWidth = 1;
    self.btn.layer.cornerRadius = 10;
    self.btn.layer.backgroundColor = BLUE_1.CGColor;
    
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)rateSliderChanged:(UISlider *)slider {
    [self.delegate valueChanged:slider.value];
}

@end
