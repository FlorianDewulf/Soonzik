//
//  AlbumViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "Album.h"
#import "AudioPlayer.h"
#import "OnLTMusicPopupView.h"
#import "TypeViewController.h"

@interface AlbumViewController : TypeViewController <UITableViewDataSource, UITableViewDelegate, PopUpDetailMusicDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IBOutlet UIVisualEffectView *visualView;
@property (nonatomic, strong) Album *album;
@property (nonatomic, strong) NSMutableArray *listOfMusics;
@property (nonatomic, assign) bool fromSearch;
@property (nonatomic, assign) bool fromCurrentList;
@property (nonatomic, assign) bool fromPack;
@property (nonatomic, strong) UIImage *albumImage;

@property (nonatomic, assign) bool dataLoaded;
@property (nonatomic, strong) UIActivityIndicatorView *spin;

@end
