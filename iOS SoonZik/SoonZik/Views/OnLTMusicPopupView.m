//
//  OnLTMusicPopupView.m
//  SoonZik
//
//  Created by LLC on 18/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "OnLTMusicPopupView.h"
#import "Tools.h"
#import "SVGKImage.h"
#import "MusicsController.h"
#import "PlaylistsController.h"
#import "SimplePopUp.h"

@implementation OnLTMusicPopupView

- (void)initPopupWithSong:(Music *)song andPlaylist:(Playlist *)playlist andTypeOfParent:(int)type
{
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.playlistDisplayMode = false;
    self.ratingDisplayMode = false;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = DARK_GREY;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.typeOfParent = type;
    
    self.alpha = 0;
    self.song = song;
    self.playlist = playlist;
    
    self.popupView.layer.masksToBounds = YES;
    self.popupView.layer.cornerRadius = 10; // if you like rounded corners
    self.popupView.layer.shadowOffset = CGSizeMake(-15, 20);
    self.popupView.layer.shadowRadius = 5;
    self.popupView.layer.shadowOpacity = 0.5;
    self.popupView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.popupView.layer.borderWidth = 1;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
    
    
    NSString *urlImage = [NSString stringWithFormat:@"%@assets/albums/%@", API_URL, self.song.albumImage];
    NSLog(@"url image : %@", urlImage);
    NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
    self.musicImage.image = [UIImage imageWithData:imageData];
    self.musicName.text = song.title;
    self.artistName.text = song.artist.username;
    
    switch (type) {
        case 0:
        {
            // Playlist
            self.listOfOptionsName = @[[self.translate.dict objectForKey:@"title_remove_from_playlist"], [self.translate.dict objectForKey:@"title_album_view"], [self.translate.dict objectForKey:@"title_artist_view"], [self.translate.dict objectForKey:@"title_rate_music"]];
            self.listOfOptionsId = @[[NSNumber numberWithInt:0], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], [NSNumber numberWithInt:7]];
        }
            break;
        case 1:
        {
            // Album
           self.listOfOptionsName = @[[self.translate.dict objectForKey:@"title_artist_view"], [self.translate.dict objectForKey:@"title_add_to_playing_list"], [self.translate.dict objectForKey:@"title_add_to_playlist"], [self.translate.dict objectForKey:@"buy_music"], [self.translate.dict objectForKey:@"title_rate_music"]];
            self.listOfOptionsId = @[[NSNumber numberWithInt:3], [NSNumber numberWithInt:1], [NSNumber numberWithInt:5], [NSNumber numberWithInt:6], [NSNumber numberWithInt:7]];
        }
            break;
        case 2:
        {
            // listening list
            self.listOfOptionsName = @[[self.translate.dict objectForKey:@"title_album_view"], [self.translate.dict objectForKey:@"title_artist_view"], [self.translate.dict objectForKey:@"title_delete_from_playing_list"], [self.translate.dict objectForKey:@"title_rate_music"]];
            self.listOfOptionsId = @[[NSNumber numberWithInt:2], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:7]];
        }
            break;
        case 3:
        {
            // music in genre
            self.listOfOptionsName = @[[self.translate.dict objectForKey:@"title_artist_view"], [self.translate.dict objectForKey:@"title_album_view"], [self.translate.dict objectForKey:@"title_add_to_playing_list"], [self.translate.dict objectForKey:@"title_add_to_playlist"], [self.translate.dict objectForKey:@"title_rate_music"]];
            self.listOfOptionsId = @[[NSNumber numberWithInt:3], [NSNumber numberWithInt:2], [NSNumber numberWithInt:1], [NSNumber numberWithInt:5], [NSNumber numberWithInt:7]];
        }
            break;
        default:
            break;
    }
    
    
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ((point.x < self.popupView.frame.origin.x) || (point.x > (self.popupView.frame.origin.x + self.popupView.frame.size.width))) {
       [self.choiceDelegate closePopUp];
    } else if ((point.y < self.popupView.frame.origin.y) || (point.y > (self.popupView.frame.origin.y + self.popupView.frame.size.height))) {
        [self.choiceDelegate closePopUp];
    }
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.ratingDisplayMode)
        return 1;
    
    return self.listOfOptionsName.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.ratingDisplayMode)
        return 162;
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.ratingDisplayMode) {
        [self.tableView registerNib:[UINib nibWithNibName:@"RatingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellRate"];
        self.ratingCell = [self.tableView dequeueReusableCellWithIdentifier:@"cellRate"];
        self.ratingCell.backgroundColor = [UIColor clearColor];

        [self.ratingCell initCell];
        self.ratingCell.slider.value = 2.0;
        
        self.ratingCell.rating = (int)self.ratingCell.slider.value;
        
        
        if (self.ratingCell.rating < 1) {
            [self.ratingCell.star1 setImage:[UIImage imageNamed:@"star_0"]];
            [self.ratingCell.star2 setImage:[UIImage imageNamed:@"star_0"]];
            [self.ratingCell.star3 setImage:[UIImage imageNamed:@"star_0"]];
            [self.ratingCell.star4 setImage:[UIImage imageNamed:@"star_0"]];
            [self.ratingCell.star5 setImage:[UIImage imageNamed:@"star_0"]];
        } else if (self.ratingCell.rating < 2) {
            [self.ratingCell.star1 setImage:[UIImage imageNamed:@"star_1"]];
            [self.ratingCell.star2 setImage:[UIImage imageNamed:@"star_0"]];
            [self.ratingCell.star3 setImage:[UIImage imageNamed:@"star_0"]];
            [self.ratingCell.star4 setImage:[UIImage imageNamed:@"star_0"]];
            [self.ratingCell.star5 setImage:[UIImage imageNamed:@"star_0"]];
        } else if (self.ratingCell.rating < 3) {
            [self.ratingCell.star1 setImage:[UIImage imageNamed:@"star_1"]];
            [self.ratingCell.star2 setImage:[UIImage imageNamed:@"star_1"]];
            [self.ratingCell.star3 setImage:[UIImage imageNamed:@"star_0"]];
            [self.ratingCell.star4 setImage:[UIImage imageNamed:@"star_0"]];
            [self.ratingCell.star5 setImage:[UIImage imageNamed:@"star_0"]];
        } else if (self.ratingCell.rating < 4) {
            [self.ratingCell.star1 setImage:[UIImage imageNamed:@"star_1"]];
            [self.ratingCell.star2 setImage:[UIImage imageNamed:@"star_1"]];
            [self.ratingCell.star3 setImage:[UIImage imageNamed:@"star_1"]];
            [self.ratingCell.star4 setImage:[UIImage imageNamed:@"star_0"]];
            [self.ratingCell.star5 setImage:[UIImage imageNamed:@"star_0"]];
        } else if (self.ratingCell.rating < 5) {
            [self.ratingCell.star1 setImage:[UIImage imageNamed:@"star_1"]];
            [self.ratingCell.star2 setImage:[UIImage imageNamed:@"star_1"]];
            [self.ratingCell.star3 setImage:[UIImage imageNamed:@"star_1"]];
            [self.ratingCell.star4 setImage:[UIImage imageNamed:@"star_1"]];
            [self.ratingCell.star5 setImage:[UIImage imageNamed:@"star_0"]];
        } else {
            [self.ratingCell.star1 setImage:[UIImage imageNamed:@"star_1"]];
            [self.ratingCell.star2 setImage:[UIImage imageNamed:@"star_1"]];
            [self.ratingCell.star3 setImage:[UIImage imageNamed:@"star_1"]];
            [self.ratingCell.star4 setImage:[UIImage imageNamed:@"star_1"]];
            [self.ratingCell.star5 setImage:[UIImage imageNamed:@"star_1"]];
        }
        
        self.ratingCell.delegate = self;
        self.ratingCell.slider.tag = 3;
        self.ratingCell.slider.minimumValue = 0.0;
        self.ratingCell.slider.maximumValue = 5.0;
        
        [self.ratingCell.btn setTitle:[self.translate.dict objectForKey:@"rate_title"] forState:UIControlStateNormal];
        [self.ratingCell.btn addTarget:self action:@selector(sendRate) forControlEvents:UIControlEventTouchUpInside];
        return self.ratingCell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellOption"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellOption"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    if (!self.playlistDisplayMode && !self.ratingDisplayMode)
        cell.textLabel.text = [self.listOfOptionsName objectAtIndex:indexPath.row];
    else if (self.playlistDisplayMode) {
        Playlist *playlist = [self.listOfOptionsName objectAtIndex:indexPath.row];
        cell.textLabel.text = playlist.title;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.playlistDisplayMode && !self.ratingDisplayMode) {
        NSNumber *identifier = [self.listOfOptionsId objectAtIndex:indexPath.row];
        
        switch ([identifier intValue]) {
            case 0:
                [self.choiceDelegate removeMusicFromPlayList:self.song and:self.playlist];
                [self.choiceDelegate closePopUp];
                break;
            case 1:
                [self.choiceDelegate addToCurrentPlaylist:self.song];
                [self.choiceDelegate closePopUp];
                break;
            case 2:
                [self.choiceDelegate goToAlbumView:self.song];
                [self.choiceDelegate closePopUp];
                break;
            case 3:
                [self.choiceDelegate goToArtistView:self.song];
                [self.choiceDelegate closePopUp];
                break;
            case 4:
                [self.choiceDelegate deleteFromCurrentList:self.song];
                [self.choiceDelegate closePopUp];
                break;
            case 5:
                [self addToAPlaylist];
                break;
            case 6:
                [self.choiceDelegate addMusicToCart:self.song];
                [self.choiceDelegate closePopUp];
                break;
            case 7:
                [self rateMusic];
                break;
            default:
                break;
        }
    }
    else if (self.playlistDisplayMode) {
        Playlist *playlist = [self.listOfOptionsName objectAtIndex:indexPath.row];
        [self.choiceDelegate addToPlaylist:playlist :self.song];
    }
}

- (void)addToAPlaylist {
    self.playlistDisplayMode = true;
    NSArray *listOfPlaylist = [self getPlaylists];
    self.listOfOptionsName = listOfPlaylist;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSArray *)getPlaylists {
    /*NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
    return [Factory findElementWithClassName:@"Playlist" andValues:[NSString stringWithFormat:@"attribute[user_id]=%i", user.identifier]];*/
    return [PlaylistsController getPlaylists];
}

- (void)rateMusic {
    self.ratingDisplayMode = true;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)valueChanged:(float)value {
    self.ratingCell.rating = (int)value;
    
    if (self.ratingCell.rating < 1) {
        [self.ratingCell.star1 setImage:[UIImage imageNamed:@"star_0"]];
        [self.ratingCell.star2 setImage:[UIImage imageNamed:@"star_0"]];
        [self.ratingCell.star3 setImage:[UIImage imageNamed:@"star_0"]];
        [self.ratingCell.star4 setImage:[UIImage imageNamed:@"star_0"]];
        [self.ratingCell.star5 setImage:[UIImage imageNamed:@"star_0"]];
    } else if (self.ratingCell.rating < 2) {
        [self.ratingCell.star1 setImage:[UIImage imageNamed:@"star_1"]];
        [self.ratingCell.star2 setImage:[UIImage imageNamed:@"star_0"]];
        [self.ratingCell.star3 setImage:[UIImage imageNamed:@"star_0"]];
        [self.ratingCell.star4 setImage:[UIImage imageNamed:@"star_0"]];
        [self.ratingCell.star5 setImage:[UIImage imageNamed:@"star_0"]];
    } else if (self.ratingCell.rating < 3) {
        [self.ratingCell.star1 setImage:[UIImage imageNamed:@"star_1"]];
        [self.ratingCell.star2 setImage:[UIImage imageNamed:@"star_1"]];
        [self.ratingCell.star3 setImage:[UIImage imageNamed:@"star_0"]];
        [self.ratingCell.star4 setImage:[UIImage imageNamed:@"star_0"]];
        [self.ratingCell.star5 setImage:[UIImage imageNamed:@"star_0"]];
    } else if (self.ratingCell.rating < 4) {
        [self.ratingCell.star1 setImage:[UIImage imageNamed:@"star_1"]];
        [self.ratingCell.star2 setImage:[UIImage imageNamed:@"star_1"]];
        [self.ratingCell.star3 setImage:[UIImage imageNamed:@"star_1"]];
        [self.ratingCell.star4 setImage:[UIImage imageNamed:@"star_0"]];
        [self.ratingCell.star5 setImage:[UIImage imageNamed:@"star_0"]];
    } else if (self.ratingCell.rating < 5) {
        [self.ratingCell.star1 setImage:[UIImage imageNamed:@"star_1"]];
        [self.ratingCell.star2 setImage:[UIImage imageNamed:@"star_1"]];
        [self.ratingCell.star3 setImage:[UIImage imageNamed:@"star_1"]];
        [self.ratingCell.star4 setImage:[UIImage imageNamed:@"star_1"]];
        [self.ratingCell.star5 setImage:[UIImage imageNamed:@"star_0"]];
    } else {
        [self.ratingCell.star1 setImage:[UIImage imageNamed:@"star_1"]];
        [self.ratingCell.star2 setImage:[UIImage imageNamed:@"star_1"]];
        [self.ratingCell.star3 setImage:[UIImage imageNamed:@"star_1"]];
        [self.ratingCell.star4 setImage:[UIImage imageNamed:@"star_1"]];
        [self.ratingCell.star5 setImage:[UIImage imageNamed:@"star_1"]];
    }

}

- (void)sendRate {
    [self.choiceDelegate closePopUp];
    if ([MusicsController rateMusic:self.song :(int)self.ratingCell.slider.value]) {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"rating_success"] onView:self.superview withSuccess:true] show];
    } else {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"rating_error"] onView:self.superview withSuccess:false] show];
    }
}

@end
