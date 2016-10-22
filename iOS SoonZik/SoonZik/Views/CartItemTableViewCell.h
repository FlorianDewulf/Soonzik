//
//  CartItemTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 18/08/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartDeleteButton.h"

@interface CartItemTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *artistLabel;
@property (nonatomic, strong) IBOutlet CartDeleteButton *deleteButton;
@property (nonatomic, strong) IBOutlet UILabel *forUserLabel;

@end
