//
//  GenreViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 30/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TypeViewController.h"
#import "OnLTMusicPopupView.h"
#import "Genre.h"

@interface GenreViewController : TypeViewController <UITableViewDataSource, UITableViewDelegate, PopUpDetailMusicDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Genre *genre;

@property (nonatomic, assign) bool dataLoaded;
@property (nonatomic, strong) UIActivityIndicatorView *spin;

@end
