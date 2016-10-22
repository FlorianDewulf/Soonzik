//
//  OnLTMusicPopupView.h
//  SoonZik
//
//  Created by LLC on 18/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Music.h"
#import "Playlist.h"
#import "Translate.h"
#import "RatingTableViewCell.h"

@protocol PopUpDetailMusicDelegate <NSObject>

- (void)goToAlbumView:(Music *)music;
- (void)goToArtistView:(Music *)music;
- (void)addToCurrentPlaylist:(Music *)music;
- (void)removeMusicFromPlayList:(Music *)music and:(Playlist *)playlist;
- (void)deleteFromCurrentList:(Music *)music;
- (void)addToPlaylist:(Playlist *)playlist :(Music *)music;
- (void)closePopUp;
- (void)addMusicToCart:(Music *)music;
- (void)rateMusic:(Music *)music :(float)rating;

@end

@interface OnLTMusicPopupView : UIView <UITableViewDataSource, UITableViewDelegate, ValueChangedProtocol>

@property (nonatomic, strong) IBOutlet UIView *popupView;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, assign) int typeOfParent;
@property (nonatomic, strong) NSArray *listOfOptionsName;
@property (nonatomic, strong) NSArray *listOfOptionsId;

@property (nonatomic, strong) IBOutlet UIImageView *musicImage;
@property (nonatomic, strong) IBOutlet UILabel *musicName;
@property (nonatomic, strong) IBOutlet UILabel *artistName;

@property (nonatomic, strong) RatingTableViewCell *ratingCell;

@property (nonatomic, strong) Translate *translate;
@property (nonatomic, strong) Playlist *playlist;
@property (nonatomic, strong) Music *song;

@property (nonatomic, strong) id<PopUpDetailMusicDelegate> choiceDelegate;

- (void)initPopupWithSong:(Music *)song andPlaylist:(Playlist *)playlist andTypeOfParent:(int)type;

@property (nonatomic, assign) bool playlistDisplayMode;
@property (nonatomic, assign) bool ratingDisplayMode;

@end
