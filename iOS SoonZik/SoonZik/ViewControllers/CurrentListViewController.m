//
//  CurrentListViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 02/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "CurrentListViewController.h"
#import "Tools.h"
#import "SVGKImage.h"
#import "PlayListsCells.h"
#import "OnLTMusicPopupView.h"
#import "AlbumViewController.h"
#import "ArtistViewController.h"

@interface CurrentListViewController ()

@end

@implementation CurrentListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    self.player = [AudioPlayer sharedCenter];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.view.backgroundColor = DARK_GREY;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    UIImage *closeImage = [Tools imageWithImage:[SVGKImage imageNamed:@"close"].UIImage scaledToSize:CGSizeMake(30, 30)];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:closeImage style:UIBarButtonItemStylePlain target:self action:@selector(closeViewController)];
    [closeButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = closeButton;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateDisplay) userInfo:nil repeats:YES];
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (void)updateDisplay {
    [self deselectAllTheRows];
    //if (self.player.oldIndex != self.player.index) {
        PlayListsCells *cell = (PlayListsCells *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.player.index inSection:0]];
        [cell setSelected:YES animated:YES];
    //}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.player.listeningList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Music *music = [self.player.listeningList objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"cellID";
    
    PlayListsCells *cell = (PlayListsCells *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"PlayListsCells" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    cell.trackArtist.text = music.artist.username;
    cell.trackTitle.text = music.title;
    [cell.optionsButton addTarget:self action:@selector(displayPopUp:) forControlEvents:UIControlEventTouchUpInside];
    cell.optionsButton.music = music;
    cell.backgroundColor = DARK_GREY;
    
    UIImage* optionImage = [Tools imageWithImage:[UIImage imageNamed:@"options_white"] scaledToSize:CGSizeMake(30, 30)];
    [cell.optionsButton setImage:optionImage forState:UIControlStateNormal];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, cell.contentView.frame.size.width, 0.5)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [cell.contentView addSubview:lineView];
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.player.index != indexPath.row) {
        Music *music = [self.player.listeningList objectAtIndex:indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.player stopSound];
        [self.player deleteCurrentPlayer];
        [self.player prepareSong:music.identifier];
       // self.player.oldIndex = self.player.index;
        self.player.index = indexPath.row;
        [self.player playSound];
        [self deselectAllTheRows];
        PlayListsCells *cell = (PlayListsCells *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:YES animated:YES];
    }
}

- (void)deselectAllTheRows {
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            PlayListsCells *cell = (PlayListsCells *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            [cell setSelected:NO animated:YES];
        }
    }
}

- (void)displayPopUp:(MusicOptionsButton *)btn
{
    [self addBlurEffectOnView:self.view];
    OnLTMusicPopupView *popUpView = (OnLTMusicPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"OnLTMusicPopupView" owner:self options:nil] objectAtIndex:0];
    popUpView.tag = 100;
    popUpView.choiceDelegate = self;
    [self.view addSubview:popUpView];
    [popUpView initPopupWithSong:btn.music andPlaylist:btn.playlist andTypeOfParent:2];
}

- (void)addBlurEffectOnView:(UIView *)view
{
    [self.navigationController setNavigationBarHidden:true animated:true];
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = view.bounds;
    visualEffectView.tag = 200;
    [view addSubview:visualEffectView];
    visualEffectView.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        visualEffectView.alpha = 1;
    }];
}

- (void)closeViewController {
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)closePopUp
{
    for (UIView *v in [self.view subviews]) {
        if (v.tag == 100) {
            [UIView animateWithDuration:1 animations:^{
                v.alpha = 0;
            } completion:^(BOOL finished) {
                [v removeFromSuperview];
            }];
        }
    }
    [self removeBlurEffect:200 onView:self.view];
}

- (void)removeBlurEffect:(int)tag onView:(UIView *)v
{
    for (UIView *view in v.subviews) {
        if (view.tag == tag) {
            [UIView animateWithDuration:0.5 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
                [self.navigationController setNavigationBarHidden:false animated:true];
            }];
        }
    }
}

- (void)goToAlbumView:(Music *)music {
    [self closePopUp];
    AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
    vc.album = [[Album alloc] init];
    vc.album.identifier = music.albumId;
    vc.fromCurrentList = true;
    [self presentViewController:vc animated:true completion:nil];
}

- (void)goToArtistView:(Music *)music {
    [self closePopUp];
    ArtistViewController *vc = [[ArtistViewController alloc] initWithNibName:@"ArtistViewController" bundle:nil];
    vc.artist = music.artist;
    vc.fromCurrentList = true;
    [self presentViewController:vc animated:true completion:nil];
}

- (void)deleteFromCurrentList:(Music *)music {
    Music *m = [self.player.listeningList objectAtIndex:self.player.index];
    if (m.identifier == music.identifier) {
       [self.player stopSound];
        [self.player deleteCurrentPlayer];
       // self.player.oldIndex = 0;
        self.player.index = 0;
    }
    
    for (int i = 0; i < self.player.listeningList.count; i++) {
        Music *m = [self.player.listeningList objectAtIndex:i];
        if (m.identifier == music.identifier) {
            [self.player.listeningList removeObjectAtIndex:i];
        }
        
    }
    
    NSMutableArray *listeningList = [[NSMutableArray alloc] init];
    for (Music *m in self.player.listeningList) {
        [listeningList addObject:m];
    }
    self.player.listeningList = listeningList;
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)view;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

@end
