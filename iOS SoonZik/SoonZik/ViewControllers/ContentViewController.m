//
//  ContentViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 09/12/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ContentViewController.h"
#import "PlaylistViewController.h"
#import "AlbumViewController.h"
#import "TitlePlaylistCollectionViewCell.h"
#import "Playlist.h"
#import "Album.h"
#import "Tools.h"
#import "SVGKImage.h"
#import "SimplePopUp.h"
#import "Pack.h"
#import "UsersController.h"
#import "PlaylistsController.h"
#import "AlbumTableViewCell.h"
#import "PackDetailViewController.h"

#define NAVIGATIONBAR_HEIGHT 50

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    [self initNavigationButtons];
    
    self.dataLoaded = NO;
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height-NAVIGATIONBAR_HEIGHT)];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = true;
    self.scrollView.scrollEnabled = false;
    self.scrollView.directionalLockEnabled = true;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*4, self.view.frame.size.height)];
    [contentView layoutIfNeeded];
    CGSize size = CGSizeMake(contentView.bounds.size.width, contentView.bounds.size.height);
    self.scrollView.contentSize = size;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(120, 148);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 24, 0, 24);
    self.playlistsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
    self.playlistsCollectionView.delegate = self;
    self.playlistsCollectionView.dataSource = self;
    self.playlistsCollectionView.tag = 1;
    [self.playlistsCollectionView setBackgroundColor:[UIColor clearColor]];
    
    [contentView addSubview:self.playlistsCollectionView];
    
    self.albumsTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.albumsTableView.delegate = self;
    self.albumsTableView.dataSource = self;
    self.albumsTableView.tag = 2;
    [self.albumsTableView setBackgroundColor:[UIColor clearColor]];
    self.albumsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:self.albumsTableView];
    
    self.musicsTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.musicsTableView.delegate = self;
    self.musicsTableView.dataSource = self;
    self.musicsTableView.tag = 3;
    [self.musicsTableView setBackgroundColor:[UIColor clearColor]];
    self.musicsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:self.musicsTableView];
    
    self.packsTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*3, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.packsTableView.delegate = self;
    self.packsTableView.dataSource = self;
    self.packsTableView.tag = 4;
    [self.packsTableView setBackgroundColor:[UIColor clearColor]];
    self.packsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:self.packsTableView];
    
    [self.scrollView addSubview:contentView];
    
    self.view.backgroundColor = DARK_GREY;
    self.playlistsCollectionView.delegate = self;
    self.playlistsCollectionView.dataSource = self;
    
    UIImage *addImage = [Tools imageWithImage:[SVGKImage imageNamed:@"add"].UIImage scaledToSize:CGSizeMake(30, 30)];
    self.addPlaylistButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.addPlaylistButton setImage:addImage forState:UIControlStateNormal];
    [self.addPlaylistButton addTarget:self action:@selector(addAPlaylist) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.addPlaylistButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.noPlaylistLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMidY(self.view.frame)/2, self.view.frame.size.width-40, 100)];
    self.noPlaylistLabel.textAlignment = NSTextAlignmentCenter;
    self.noPlaylistLabel.numberOfLines = 3;
    self.noPlaylistLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
    self.noPlaylistLabel.textColor = [UIColor whiteColor];
    self.noPlaylistLabel.text = [self.translate.dict objectForKey:@"no_playlist"];
    [self.view addSubview:self.noPlaylistLabel];
}


- (void)getData {
    self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spin.center = self.view.center;
    [self.view addSubview:self.spin];
    [self.spin startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        [self getAllPlaylists];
        self.boughtContent = [UsersController getContent];
        NSLog(@"self.boughtContent.listOfAlbums.count: %i", self.boughtContent.listOfAlbums.count);
        NSLog(@"self.boughtContent.listOfMusics.count: %i", self.boughtContent.listOfMusics.count);
        NSLog(@"self.boughtContent.listOfPacks.count: %i", self.boughtContent.listOfPacks.count);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self.spin stopAnimating];
            self.dataLoaded = true;
            [self.playlistsCollectionView reloadData];
            [self.albumsTableView reloadData];
            [self.musicsTableView reloadData];
            [self.packsTableView reloadData];
        });
    });
}

- (void)initNavigationButtons { 
    UIView *navigationArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, NAVIGATIONBAR_HEIGHT)];
    
    self.playlistButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/4, navigationArea.frame.size.height)];
    [self.playlistButton setTitle:[self.translate.dict objectForKey:@"title_playlists"] forState:UIControlStateNormal];
    [self.playlistButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.playlistButton addTarget:self action:@selector(moveToTheGoodView:) forControlEvents:UIControlEventTouchUpInside];
    self.playlistButton.tag = 1;
    [navigationArea addSubview:self.playlistButton];
    
    self.albumButton = [[UIButton alloc] initWithFrame:CGRectMake(self.playlistButton.frame.size.width, 0, self.playlistButton.frame.size.width, navigationArea.frame.size.height)];
    [self.albumButton setTitle:[self.translate.dict objectForKey:@"title_albums"] forState:UIControlStateNormal];
    [self.albumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.albumButton addTarget:self action:@selector(moveToTheGoodView:) forControlEvents:UIControlEventTouchUpInside];
    self.albumButton.tag = 2;
    [navigationArea addSubview:self.albumButton];
    
    self.musicButton = [[UIButton alloc] initWithFrame:CGRectMake(self.playlistButton.frame.size.width*2, 0, self.playlistButton.frame.size.width, navigationArea.frame.size.height)];
    [self.musicButton setTitle:[self.translate.dict objectForKey:@"title_musics"] forState:UIControlStateNormal];
    [self.musicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.musicButton addTarget:self action:@selector(moveToTheGoodView:) forControlEvents:UIControlEventTouchUpInside];
    self.musicButton.tag = 3;
    [navigationArea addSubview:self.musicButton];
    
    self.packButton = [[UIButton alloc] initWithFrame:CGRectMake(self.playlistButton.frame.size.width*3, 0, self.playlistButton.frame.size.width, navigationArea.frame.size.height)];
    [self.packButton setTitle:[self.translate.dict objectForKey:@"title_packs"] forState:UIControlStateNormal];
    [self.packButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.packButton addTarget:self action:@selector(moveToTheGoodView:) forControlEvents:UIControlEventTouchUpInside];
    self.packButton.tag = 4;
    [navigationArea addSubview:self.packButton];
    
    [self.playlistButton setTitleColor:BLUE_1 forState:UIControlStateNormal];
    
    [self.view addSubview:navigationArea];
}

- (void)moveToTheGoodView:(UIButton *)btn {
    [self selectTheRightButton:btn.tag];
    switch (btn.tag) {
        case 1:
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:true];
            [self.addPlaylistButton setHidden:false];
            break;
        case 2:
            [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:true];
            [self.addPlaylistButton setHidden:true];
            break;
        case 3:
            [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width*2, 0) animated:true];
            [self.addPlaylistButton setHidden:true];
            break;
        case 4:
            [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width*3, 0) animated:true];
            [self.addPlaylistButton setHidden:true];
            break;
        default:
            break;
    }
}

- (void)selectTheRightButton:(int)tag {
    switch (tag) {
        case 1:
            [self.playlistButton setTitleColor:BLUE_1 forState:UIControlStateNormal];
            [self.albumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.musicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.packButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 2:
            [self.playlistButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.albumButton setTitleColor:BLUE_1 forState:UIControlStateNormal];
            [self.musicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.packButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 3:
            [self.playlistButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.albumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.musicButton setTitleColor:BLUE_1 forState:UIControlStateNormal];
            [self.packButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case 4:
            [self.playlistButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.albumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.musicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.packButton setTitleColor:BLUE_1 forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)checkPlaylists
{
    if (self.listOfPlaylists.count == 0) {
        [self.playlistsCollectionView setHidden:YES];
        [self.noPlaylistLabel setHidden:NO];
    } else {
        [self.playlistsCollectionView setHidden:NO];
        [self.noPlaylistLabel setHidden:YES];
    }
}

- (void)getAllPlaylists
{
    self.listOfPlaylists = [PlaylistsController getPlaylists];
    [self checkPlaylists];
}

#pragma mark - CollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataLoaded)
        return self.listOfPlaylists.count;
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    [collectionView registerNib:[UINib nibWithNibName:@"TitlePlaylistCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    TitlePlaylistCollectionViewCell *cell = (TitlePlaylistCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (self.listOfPlaylists.count > 0) {
        [cell initCell];
        Playlist *playlist = [self.listOfPlaylists objectAtIndex:indexPath.row];
        NSLog(@"playlist.listofmusics : %i", playlist.listOfMusics.count);
        cell.playlistTitle.text = playlist.title;
        cell = [self loadImagePreviewPlaylist:playlist.listOfMusics forCell:cell];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Playlist *playlist = [self.listOfPlaylists objectAtIndex:indexPath.row];
    
    PlaylistViewController *vc = [[PlaylistViewController alloc] initWithNibName:@"PlaylistViewController" bundle:nil];
    vc.playlist = playlist;
    vc.reloadDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TableViews

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataLoaded) {
        if (tableView.tag == 2) {
            return self.boughtContent.listOfAlbums.count;
        } else if (tableView.tag == 3) {
            return self.boughtContent.listOfMusics.count;
        } else if (tableView.tag == 4) {
            return self.boughtContent.listOfPacks.count;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView.tag == 2) {
        AlbumTableViewCell *cell = (AlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellAlbums"];
        if (!cell) {
            cell = (AlbumTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"AlbumTableViewCell" owner:self options:nil] firstObject];
        }
        Album *album = [self.boughtContent.listOfAlbums objectAtIndex:indexPath.row];
        cell.albumLabel.text = album.title;
        cell.albumLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.albumLabel.font = SOONZIK_FONT_BODY_SMALL;
        
        NSString *urlImage = [NSString stringWithFormat:@"%@assets/albums/%@", API_URL, album.image];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
        cell.albumImage.image = [UIImage imageWithData:imageData];
        
        return cell;
    } else if (tableView.tag == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellMusics"];
        Music *music = [self.boughtContent.listOfMusics objectAtIndex:indexPath.row];
        cell.textLabel.text = music.title;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = SOONZIK_FONT_BODY_SMALL;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellPacks"];
    Pack *pack = [self.boughtContent.listOfPacks objectAtIndex:indexPath.row];
    cell.textLabel.text = pack.title;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = SOONZIK_FONT_BODY_SMALL;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 2) {
        Album *album = [self.boughtContent.listOfAlbums objectAtIndex:indexPath.row];
        AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
        vc.album = album;
        [self presentViewController:vc animated:YES completion:nil];
    } else if (tableView.tag == 3) {
        Music *music = [self.boughtContent.listOfMusics objectAtIndex:indexPath.row];
        AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
        vc.album = [[Album alloc] init];
        vc.album.identifier = music.albumId;
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        Pack *pack = [self.boughtContent.listOfPacks objectAtIndex:indexPath.row];
        PackDetailViewController *packVC = [[PackDetailViewController alloc] initWithNibName:@"PackDetailViewController" bundle:nil];
        packVC.pack = pack;
        packVC.fromSearch = false;
        [self presentViewController:packVC animated:YES completion:nil];
    }
}

- (TitlePlaylistCollectionViewCell *)loadImagePreviewPlaylist:(NSArray *)playlist forCell:(TitlePlaylistCollectionViewCell *)cell
{
    if (playlist.count > 0) {
        Music *music1 = playlist[0];
        NSString *urlImage = [NSString stringWithFormat:@"%@assets/albums/%@", API_URL, music1.albumImage];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
        cell.album1Image.image = [UIImage imageWithData:imageData];
    }
    if (playlist.count > 1) {
        Music *music2 = playlist[1];
        NSString *urlImage2 = [NSString stringWithFormat:@"%@assets/albums/%@", API_URL, music2.albumImage];
        NSData *imageData2 = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage2]];
        cell.album2Image.image = [UIImage imageWithData:imageData2];
    }
    if (playlist.count > 2) {
        Music *music3 = playlist[2];
        NSString *urlImage3 = [NSString stringWithFormat:@"%@assets/albums/%@", API_URL, music3.albumImage];
        NSData *imageData3 = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage3]];
        cell.album3Image.image = [UIImage imageWithData:imageData3];
    }
    if (playlist.count > 3) {
        Music *music4 = playlist[3];
        NSString *urlImage4 = [NSString stringWithFormat:@"%@assets/albums/%@", API_URL, music4.albumImage];
        NSData *imageData4 = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage4]];
        cell.album4Image.image = [UIImage imageWithData:imageData4];
    }
    
    return cell;
}

- (void)addAPlaylist
{
    UIAlertView *popUp = [[UIAlertView alloc] initWithTitle:[self.translate.dict objectForKey:@"playlist_create_title"] message:[self.translate.dict objectForKey:@"playlist_enter_title"] delegate:self cancelButtonTitle:[self.translate.dict objectForKey:@"cancel"] otherButtonTitles:[self.translate.dict objectForKey:@"save"], nil];
    [popUp setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [popUp show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self createAPlaylist:[alertView textFieldAtIndex:0].text];
            break;
        default:
            break;
    }
}

- (void)createAPlaylist:(NSString *)title
{
    Playlist *playlist = [[Playlist alloc] init];
    playlist.title = title;
    
    Playlist *p = [PlaylistsController createAPlaylist:playlist];
    if (p.identifier != -1) {
        [self getAllPlaylists];
        [self.playlistsCollectionView reloadData];
    } else {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"playlist_create_synthaxe"] onView:self.view withSuccess:false] show];
    }
}

- (void)reloadList {
    [self getAllPlaylists];
}

@end
