//
//  RepartionTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 02/08/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepartionTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UILabel *value;

@end
