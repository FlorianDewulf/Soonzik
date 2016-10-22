//
//  ContentViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/12/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"
#import "ReloadPlaylistsDelegate.h"
#import "BoughtContent.h"

@interface ContentViewController : TypeViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, ReloadPlaylistsDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *albumsTableView;
@property (nonatomic, strong) UITableView *musicsTableView;
@property (nonatomic, strong) UITableView *packsTableView;
@property (nonatomic, strong) UICollectionView *playlistsCollectionView;
@property (nonatomic, strong) NSMutableArray *listOfPlaylists;
@property (nonatomic, strong) NSMutableArray *listOfAlbums;
@property (nonatomic, strong) UIButton *addPlaylistButton;
@property (nonatomic, strong) UIButton *playlistButton;
@property (nonatomic, strong) UIButton *albumButton;
@property (nonatomic, strong) UIButton *musicButton;
@property (nonatomic, strong) UIButton *packButton;
@property (nonatomic, strong) UILabel *noPlaylistLabel;
@property (nonatomic, strong) BoughtContent *boughtContent;

@property (nonatomic, assign) bool dataLoaded;
@property (nonatomic, strong) UIActivityIndicatorView *spin;

@end
