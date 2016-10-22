//
//  MusicTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicOptionsButton.h"

@interface MusicTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *musicTitle;
@property (nonatomic, strong) IBOutlet UILabel *musicLength;
@property (nonatomic, strong) IBOutlet MusicOptionsButton *optionsButton;

- (void)initCell;

@end
