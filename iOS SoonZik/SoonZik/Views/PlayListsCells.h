//
//  PlayListsCells.h
//  SoonZik
//
//  Created by LLC on 25/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "MusicOptionsButton.h"

@interface PlayListsCells : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *trackTitle;
@property (nonatomic, strong) IBOutlet UILabel *trackArtist;
@property (nonatomic, strong) IBOutlet MusicOptionsButton *optionsButton;

- (void)initCell;

@end
