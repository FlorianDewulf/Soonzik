//
//  GenreViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 30/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "GenreViewController.h"
#import "PlayListsCells.h"
#import "Music.h"
#import "Tools.h"
#import "GenresController.h"
#import "AlbumViewController.h"
#import "ArtistViewController.h"
#import "AppDelegate.h"
#import "SimplePopUp.h"
#import "CartViewController.h"
#import "CartController.h"
#import "PlaylistsController.h"

@interface GenreViewController ()

@end

@implementation GenreViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = false;
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = false;
    self.navigationItem.leftBarButtonItems = nil;
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = DARK_GREY;
    
    self.dataLoaded = NO;
    [self getData];
}

- (void)getData {
    self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spin.center = self.view.center;
    [self.view addSubview:self.spin];
    [self.spin startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        self.genre = [GenresController getGenre:self.genre.identifier];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self.spin stopAnimating];
            self.dataLoaded = true;
            [self.tableView reloadData];
        });
    });
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataLoaded) {
        return self.genre.listOfMusics.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Music *music = [self.genre.listOfMusics objectAtIndex:indexPath.row];
    
    PlayListsCells *cell = (PlayListsCells *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PlayListsCells" bundle:nil] forCellReuseIdentifier:@"cell"];
        cell = (PlayListsCells *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    [cell initCell];
    
    cell.trackTitle.text = music.title;
    cell.trackArtist.text = music.artist.username;
    [cell.optionsButton addTarget:self action:@selector(displayPopUp:) forControlEvents:UIControlEventTouchUpInside];
    cell.optionsButton.music = music;
    
    UIImage* optionImage = [Tools imageWithImage:[UIImage imageNamed:@"options_white"] scaledToSize:CGSizeMake(30, 30)];
    [cell.optionsButton setImage:optionImage forState:UIControlStateNormal];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, cell.contentView.frame.size.width, 0.5)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [cell.contentView addSubview:lineView];

    
    return cell;
}

- (void)displayPopUp:(MusicOptionsButton *)btn
{
    [self addBlurEffectOnView:self.view];
    OnLTMusicPopupView *popUpView = (OnLTMusicPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"OnLTMusicPopupView" owner:self options:nil] objectAtIndex:0];
    popUpView.tag = 100;
    popUpView.choiceDelegate = self;
    [self.view addSubview:popUpView];
    [popUpView initPopupWithSong:btn.music andPlaylist:btn.playlist andTypeOfParent:3];
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

- (void)goToAlbumView:(Music *)music
{
    [self closePopUp];
    AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
    vc.album = [[Album alloc] init];
    vc.album.identifier = music.albumId;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)addToPlaylist:(Playlist *)playlist :(Music *)music
{
    if ([PlaylistsController addToPlaylist:playlist :music]) {
        [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"music_added_playlist"], music.title, playlist.title] onView:self.view withSuccess:true] show];
    } else {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"music_added_playlist_error"] onView:self.view withSuccess:false] show];
    }
    
    [self closePopUp];
}

- (void)goToArtistView:(Music *)music
{
    [self closePopUp];
    ArtistViewController *vc = [[ArtistViewController alloc] initWithNibName:@"ArtistViewController" bundle:nil];
    vc.artist = music.artist;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Music *s = [self.genre.listOfMusics objectAtIndex:indexPath.row];
    
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

- (void)addToCurrentPlaylist:(Music *)music
{
    [self closePopUp];
    //self.player = ((AppDelegate *)[UIApplication sharedApplication].delegate).thePlayer;
    self.player = [AudioPlayer sharedCenter];
    //music.artist.username = self.album.artist.username;
    [self.player.listeningList addObject:music];
    
    [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"music_added_current_list"], music.title] onView:self.view] show];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(closePopUp) userInfo:nil repeats:NO];
}

- (void)popUpBuy {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Acheter" message:@"voulez vous acheter cet album?" delegate:self cancelButtonTitle:@"non" otherButtonTitles:@"oui", nil];
    alert.backgroundColor = DARK_GREY;
    [alert show];
}

- (void)addMusicToCart:(Music *)music {
    if ([CartController addToCart:@"Music" :music.identifier] != nil){
        [[[SimplePopUp alloc] initWithMessage:@"Ajout au panier réussi" onView:self.view withSuccess:true] show];
    } else {
        [[[SimplePopUp alloc] initWithMessage:@"Erreur lors de l'ajout au panier" onView:self.view withSuccess:false] show];
    }
}

@end
