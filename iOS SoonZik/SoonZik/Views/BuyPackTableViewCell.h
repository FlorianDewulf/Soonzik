//
//  BuyPackTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 22/03/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyPackTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton *buyButton;

- (void)initCell;

@end
