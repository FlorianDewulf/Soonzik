//
//  BattleTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 30/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "User.h"
#import <UIKit/UIKit.h>

@interface BattleTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imgv1;
@property (nonatomic, strong) IBOutlet UIImageView *imgv2;
@property (nonatomic, strong) IBOutlet UILabel *label1;
@property (nonatomic, strong) IBOutlet UILabel *labelVS;
@property (nonatomic, strong) IBOutlet UILabel *label2;

- (void)initCell:(User *)artist1 :(User *)artist2;

@end
