//
//  BuyPackValueTableViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 21/12/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "BuyPackValueTableViewCell.h"

@implementation BuyPackValueTableViewCell

- (void)awakeFromNib {
    self.textField.textColor = [UIColor whiteColor];
    self.textField.tintColor = [UIColor whiteColor];
    self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
