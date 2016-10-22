//
//  CurrentListViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 02/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TypeViewController.h"
#import "AudioPlayer.h"
#import "AppDelegate.h"

#import <UIKit/UIKit.h>

#import "OnLTMusicPopupView.h"

@interface CurrentListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PopUpDetailMusicDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;

@end
