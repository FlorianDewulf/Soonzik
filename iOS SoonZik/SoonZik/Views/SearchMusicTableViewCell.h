//
//  SearchMusicTableViewCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 17/04/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Music.h"
#import "Pack.h"

@interface SearchMusicTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *musicLabel;

- (void)initCell:(id)elem;

@end
