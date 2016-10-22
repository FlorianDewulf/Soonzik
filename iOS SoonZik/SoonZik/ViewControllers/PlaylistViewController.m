//
//  PlaylistViewController.m
//  SoonZik
//
//  Created by LLC on 24/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "PlaylistViewController.h"
#import "PlayListsCells.h"
#import "AppDelegate.h"
#import "Music.h"
#import "ArtistViewController.h"
#import "MusicOptionsButton.h"
#import "AlbumViewController.h"
#import "SVGKImage.h"
#import "Tools.h"
#import "SimplePopUp.h"
#import "PlaylistsController.h"

@interface PlaylistViewController ()

@end

@implementation PlaylistViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:[self.translate.dict objectForKey:@"delete"] style:UIBarButtonItemStyleDone target:self action:@selector(deletePlaylist)];
    deleteButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = deleteButton;
    
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.leftBarButtonItem = nil;
    
    self.view.backgroundColor = DARK_GREY;
    
    self.playlistTableView.dataSource = self;
    self.playlistTableView.delegate = self;
    self.playlistTableView.backgroundColor = [UIColor clearColor];
    
    self.title = self.playlist.title;
    
    self.noContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMidY(self.view.frame)/2, self.view.frame.size.width-40, 100)];
    self.noContentLabel.textAlignment = NSTextAlignmentCenter;
    self.noContentLabel.numberOfLines = 3;
    self.noContentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
    self.noContentLabel.textColor = [UIColor whiteColor];
    self.noContentLabel.text = [self.translate.dict objectForKey:@"no_playlist_content"];
    [self.view addSubview:self.noContentLabel];
    
    [self checkPlaylist];
}

- (void)checkPlaylist
{
    if (self.playlist.listOfMusics.count == 0) {
        [self.playlistTableView setHidden:YES];
        [self.noContentLabel setHidden:NO];
    } else {
        [self.playlistTableView setHidden:NO];
        [self.noContentLabel setHidden:YES];
    }
}

- (void)deletePlaylist {
    if ([PlaylistsController deletePlaylist:self.playlist.identifier]) {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"playlist_deleted"] onView:self.view withSuccess:true] show];
        [self.navigationController popViewControllerAnimated:YES];
        [self.reloadDelegate reloadList];
    } else {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"playlist_deleted_error"] onView:self.view withSuccess:false] show];
    }
}

- (void)goToAlbumView:(Music *)music
{
    [self closePopUp];
    AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
    vc.album = [[Album alloc] init];
    vc.album.identifier = music.albumId;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)goToArtistView:(Music *)music
{
    [self closePopUp];
    ArtistViewController *vc = [[ArtistViewController alloc] initWithNibName:@"ArtistViewController" bundle:nil];
    vc.artist = music.artist;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)addToCurrentPlaylist:(Music *)music
{
    [self closePopUp];
    //self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    self.player = [AudioPlayer sharedCenter];
    [self.player.listeningList addObject:music];
    
    [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"music_added_current_list"], music.title] onView:self.view withSuccess:true] show];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(closePopUp) userInfo:nil repeats:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playlist.listOfMusics.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *playAllButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 4, 312, 36)];
    [playAllButton setTitle:[self.translate.dict objectForKey:@"play_all"] forState:UIControlStateNormal];
    [playAllButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:25]];
    [playAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playAllButton addTarget:self action:@selector(playAllPlaylist) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:playAllButton];
    
    return view;
    
}

- (void)displayPopUp:(MusicOptionsButton *)btn
{
    [self addBlurEffectOnView:self.view];
    OnLTMusicPopupView *popUpView = (OnLTMusicPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"OnLTMusicPopupView" owner:self options:nil] objectAtIndex:0];
    popUpView.tag = 100;
    popUpView.choiceDelegate = self;
    [self.view addSubview:popUpView];
    [popUpView initPopupWithSong:btn.music andPlaylist:btn.playlist andTypeOfParent:0];
}

- (void) playAllPlaylist
{
    //self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    self.player = [AudioPlayer sharedCenter];
    self.player.listeningList = [[NSMutableArray alloc] init];
 //   [self.player stopSound];
    self.player.currentlyPlaying = NO;
    self.player.index = 0;
    //self.player.oldIndex = 0;
    
    for (Music *music in self.playlist.listOfMusics) {
        [self.player.listeningList addObject:music];
    }
    
    Music *music = [self.player.listeningList objectAtIndex:0];
    [self.player prepareSong:music.identifier];
 //   [self.player playSound];
}

- (void)removeMusicFromPlayList:(Music *)music and:(Playlist *)playlist {
    if ([PlaylistsController removeFromPlaylist:playlist :music]) {
        [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"playlist_delete_music"], music.title] onView:self.view withSuccess:YES] show];
        for (int i=0; i<self.playlist.listOfMusics.count; i++) {
            Music *m = [self.playlist.listOfMusics objectAtIndex:i];
            if (music.identifier == m.identifier) {
                [self.playlist.listOfMusics removeObjectAtIndex:i];
            }
        }
        [self.playlistTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"playlists_deleted_error"] onView:self.view withSuccess:NO] show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    PlayListsCells *cell = (PlayListsCells *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"PlayListsCells" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    [cell initCell];
    
    Music *s = [self.playlist.listOfMusics objectAtIndex:indexPath.row];
    cell.trackTitle.text = s.title;
    cell.trackArtist.text = s.artist.username;
    [cell.optionsButton addTarget:self action:@selector(displayPopUp:) forControlEvents:UIControlEventTouchUpInside];
    cell.optionsButton.music = s;
    cell.optionsButton.playlist = self.playlist;
    
    UIImage* optionImage = [Tools imageWithImage:[UIImage imageNamed:@"options_white"] scaledToSize:CGSizeMake(30, 30)];
    [cell.optionsButton setImage:optionImage forState:UIControlStateNormal];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, cell.contentView.frame.size.width, 0.5)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [cell.contentView addSubview:lineView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Music *s = [self.playlist.listOfMusics objectAtIndex:indexPath.row];
    
    //self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    self.player = [AudioPlayer sharedCenter];
    if ([self.player currentlyPlaying])
//        [self.player pauseSound];
    self.player.listeningList = nil;
    self.player.listeningList = [[NSMutableArray alloc] init];
    [self.player.listeningList addObject:s];
    self.player.index = 0;
    [self.player prepareSong:s.identifier];
//    [self.player playSound];
    self.player.songName = s.title;
}

@end
