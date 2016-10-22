//
//  PlaylistViewController.h
//  SoonZik
//
//  Created by LLC on 24/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeViewController.h"
#import "OnLTMusicPopupView.h"
#import "SWTableViewCell.h"
#import "ReloadPlaylistsDelegate.h"

@interface PlaylistViewController : TypeViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, PopUpDetailMusicDelegate>

@property (nonatomic, strong) IBOutlet UITableView *playlistTableView;
@property (nonatomic, strong) NSMutableArray *tracks;
@property (nonatomic, strong) Playlist *playlist;
@property (nonatomic, strong) UILabel *noContentLabel;

@property (nonatomic, strong) id<ReloadPlaylistsDelegate> reloadDelegate;

@end
