//
//  AlbumViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 09/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "AlbumViewController.h"
#import "HeaderAlbumTableView.h"
#import "AppDelegate.h"
#import "SVGKImage.h"
#import "MusicTableViewCell.h"
#import "MusicOptionsButton.h"
#import "ArtistViewController.h"
#import "Tools.h"
#import "SimplePopUp.h"
#import "PlaylistsController.h"
#import "CartViewController.h"
#import "CartController.h"
#import "LikesController.h"

@interface AlbumViewController ()

@end

@implementation AlbumViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 4, 36, 36)];
    [closeButton setImage:[SVGKImage imageNamed:@"delete"].UIImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    if (self.fromSearch) {
        closeButton.hidden = true;
        self.navigationController.navigationBarHidden = false;
        [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
    } else if (self.fromCurrentList) {
        closeButton.hidden = false;
        self.navigationController.navigationBarHidden = false;
        [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
    } else if (self.fromPack) {
        closeButton.hidden = true;
        self.navigationController.navigationBarHidden = false;
        self.navigationItem.leftBarButtonItem = nil;
        [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
    } else {
         [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.albumImage = [UIImage imageNamed:@"empty_list"];
    self.dataLoaded = NO;
    [self getData];
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = DARK_GREY;
}

- (void)getData {
    self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spin.center = self.view.center;
    [self.view addSubview:self.spin];
    [self.spin startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        self.album = [Factory provideObjectWithClassName:@"Album" andIdentifier:self.album.identifier];
        self.listOfMusics = self.album.listOfMusics;
        NSLog(@"self.album.hasliked : %i", self.album.isLiked);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self.spin stopAnimating];
            self.dataLoaded = true;
            [self.tableview reloadData];
        });
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listOfMusics.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderAlbumTableView *view = (HeaderAlbumTableView *)[[[NSBundle mainBundle] loadNibNamed:@"HeaderAlbumTableView" owner:self options:nil] firstObject];
    
   if (self.dataLoaded) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/albums/%@", API_URL, self.album.image];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.albumImage = [UIImage imageWithData:imageData];
                self.visualView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithData:imageData]];
                
                [self.spin stopAnimating];
                self.dataLoaded = true;
                [self.tableview reloadData];
            });
        });
    }
    
    view.albumImage.image = self.albumImage;
    view.albumTitle.text = self.album.title;
    view.artistLabel.text = self.album.artist.username;
    if (self.album.identifier <= 1) {
        view.numberLikesLabel.text = [NSString stringWithFormat:@"%i like", self.album.identifier];
    } else {
        view.numberLikesLabel.text = [NSString stringWithFormat:@"%i likes", self.album.identifier];
    }
    
    view.backgroundColor = [UIColor clearColor];
    
    [view.buyButton addTarget:self action:@selector(popUpBuy) forControlEvents:UIControlEventTouchUpInside];
    [view.buyButton setTitle:[self.translate.dict objectForKey:@"buy_now"] forState:UIControlStateNormal];
    
    view.albumTitle.textColor = [UIColor blackColor];
    view.albumTitle.layer.shadowColor = [UIColor whiteColor].CGColor;
    view.albumTitle.layer.shadowRadius = 2.0f;
    view.albumTitle.layer.shadowOpacity = 1;
    view.albumTitle.layer.shadowOffset = CGSizeZero;
    view.albumTitle.layer.masksToBounds = NO;
    
    view.artistLabel.textColor = [UIColor blackColor];
    view.artistLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
    view.artistLabel.layer.shadowRadius = 2.0f;
    view.artistLabel.layer.shadowOpacity = 1;
    view.artistLabel.layer.shadowOffset = CGSizeZero;
    view.artistLabel.layer.masksToBounds = NO;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-40, view.frame.size.width, 46)];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = v.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1 alpha:0], (id)DARK_GREY.CGColor, nil];
    [v.layer insertSublayer:gradient atIndex:0];
    [view addSubview:v];
    
    [view initHeader];
    
    UIButton *shareButton = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-30, v.frame.origin.y + 10, 26, 26)];
    [shareButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"share_white"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(launchShareView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shareButton];
    
    UIButton *artistButton = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-30-30-10, v.frame.origin.y + 10, 26, 26)];
    [artistButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"user"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [artistButton addTarget:self action:@selector(goToArtistView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:artistButton];
    
   /* UIButton *playAllButton = [[UIButton alloc] initWithFrame:CGRectMake(5, v.frame.origin.y + 10, 100, 26)];
    [playAllButton setTitle:[self.translate.dict objectForKey:@"play_all"] forState:UIControlStateNormal];
    [playAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playAllButton addTarget:self action:@selector(playAlbum) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:playAllButton];*/
    
    UIButton *likeButton = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-30-30-30-10, v.frame.origin.y + 10, 26, 26)];
    if (self.album.isLiked) {
        [likeButton setImage:[Tools imageWithImage:[UIImage imageNamed:@"love_1"] scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    } else {
        [likeButton setImage:[Tools imageWithImage:[UIImage imageNamed:@"love_0"] scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    }
    [likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    [likeButton setTintColor:[UIColor whiteColor]];
    [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:likeButton];
    
    return view;
}

- (void)like:(UIButton *)btn {
    if (self.album.isLiked) {
        // send dislike
        if (![LikesController dislike:self.album.identifier forObjectType:@"Albums"]) {
            [[[SimplePopUp alloc] initWithMessage:@"An error occured on this action" onView:self.view withSuccess:false] show];
        } else {
            [btn setImage:[Tools imageWithImage:[UIImage imageNamed:@"love_0"] scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
            self.album.isLiked = false;
        }
    } else {
        // send like
        if (![LikesController like:self.album.identifier forObjectType:@"Albums"]) {
            [[[SimplePopUp alloc] initWithMessage:@"An error occured on this action" onView:self.view withSuccess:false] show];
        } else {
            [btn setImage:[Tools imageWithImage:[UIImage imageNamed:@"love_1"] scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
            self.album.isLiked = true;
        }
    }
    // get album info
    //reload tableView
}

- (void)launchShareView {
    [self launchShareView:self.album];
}

- (void)closeView {
    [self.shareView removeFromSuperview];
    [self removeBlurEffect:200 onView:self.view];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"MusicTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }

    Music *music = [self.listOfMusics objectAtIndex:indexPath.row];
    music.artist = self.album.artist;
    
    [cell initCell];
    
    cell.musicTitle.text = music.title;
    cell.musicLength.text = [NSString stringWithFormat:@"%.2i:%.2i", music.duration/60, music.duration%60];
    [cell.optionsButton addTarget:self action:@selector(displayPopUp:) forControlEvents:UIControlEventTouchUpInside];
    cell.optionsButton.music = music;
    cell.backgroundColor = DARK_GREY;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, cell.contentView.frame.size.width, 0.5)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [cell.contentView addSubview:lineView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Music *s = [self.listOfMusics objectAtIndex:indexPath.row];
    self.player = [AudioPlayer sharedCenter];
    [self.player stopSound];
    [self.player deleteCurrentPlayer];
    self.player.listeningList = [[NSMutableArray alloc] init];
    [self.player.listeningList addObject:s];
    self.player.index = 0;
    [self.player prepareSong:s.identifier];
    //self.player.songName = s.title;
    
    [self deselectAllTheRows];
    MusicTableViewCell *cell = (MusicTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES animated:YES];
    
    
    
    
  /*  Music *s = [self.listOfMusics objectAtIndex:indexPath.row];
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
   */
    
}

- (void)deselectAllTheRows {
    for (NSInteger j = 0; j < [self.tableview numberOfSections]; ++j) {
        for (NSInteger i = 0; i < [self.tableview numberOfRowsInSection:j]; ++i) {
            MusicTableViewCell *cell = (MusicTableViewCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            [cell setSelected:NO animated:YES];
        }
    }
}

- (void) playAlbum
{
    self.player = [AudioPlayer sharedCenter];
    self.player.listeningList = [[NSMutableArray alloc] init];
//    [self.player stopSound];
    self.player.currentlyPlaying = NO;
    self.player.index = 0;
   // self.player.oldIndex = 0;
    
    for (Music *music in self.listOfMusics) {
        [self.player.listeningList addObject:music];
    }
    
    [AudioPlayer sharedCenter].listeningList = self.player.listeningList;

    Music *music = [self.player.listeningList objectAtIndex:0];
    [self.player prepareSong:music.identifier];
//    [self.player playSound];
}

- (void)displayPopUp:(MusicOptionsButton *)btn
{
    [self addBlurEffectOnView:self.view];
    OnLTMusicPopupView *popUpView = (OnLTMusicPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"OnLTMusicPopupView" owner:self options:nil] objectAtIndex:0];
    popUpView.tag = 100;
    popUpView.choiceDelegate = self;
    [self.view addSubview:popUpView];
    [popUpView initPopupWithSong:btn.music andPlaylist:btn.playlist andTypeOfParent:1];
}

- (void)goToArtistView:(Music *)music
{
    [self closePopUp];
    
    ArtistViewController *vc = [[ArtistViewController alloc] initWithNibName:@"ArtistViewController" bundle:nil];
    vc.artist = self.album.artist;
    
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

- (void)addToCurrentPlaylist:(Music *)music
{
    [self closePopUp];
    self.player = [AudioPlayer sharedCenter];
    music.artist.username = self.album.artist.username;
    [self.player.listeningList addObject:music];
    
    [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"music_added_current_list"], music.title] onView:self.view] show];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(closePopUp) userInfo:nil repeats:NO];
}

- (void)popUpBuy {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[self.translate.dict objectForKey:@"ask_buy_album"] delegate:self cancelButtonTitle:[self.translate.dict objectForKey:@"no"] otherButtonTitles:[self.translate.dict objectForKey:@"yes"], nil];
    alert.backgroundColor = DARK_GREY;
    [alert show];
}

- (void)addMusicToCart:(Music *)music {
    if ([CartController addToCart:@"Music" :music.identifier] != nil){
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"add_to_cart_success"] onView:self.view withSuccess:true] show];
    } else {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"add_to_cart_success"] onView:self.view withSuccess:false] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([CartController addToCart:@"Album" :self.album.identifier] != nil) {
            [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"add_to_cart_success"] onView:self.view withSuccess:true] show];
        } else {
            [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"add_to_cart_success"] onView:self.view withSuccess:false] show];
        }
    }
}



@end
