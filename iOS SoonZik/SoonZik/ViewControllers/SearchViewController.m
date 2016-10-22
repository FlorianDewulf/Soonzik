//
//  SearchViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 23/02/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import "SearchViewController.h"
#import "Factory.h"
#import "Album.h"
#import "Music.h"
#import "User.h"
#import "SearchAlbumTableViewCell.h"
#import "SearchArtistTableViewCell.h"
#import "SearchMusicTableViewCell.h"
#import "AlbumViewController.h"
#import "ArtistViewController.h"
#import "SearchsController.h"
#import "Pack.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataLoaded = NO;
    
    self.view.backgroundColor = BLUE_2;
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.searchBar.delegate = self;
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.hidden = YES;
    self.noResultLabel.hidden = NO;
    self.noResultLabel.text = [self.translate.dict objectForKey:@"search_no_result"];
    self.searchBar.placeholder = [self.translate.dict objectForKey:@"title_search"];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableData = [[NSMutableArray alloc] init];
}

- (void)getData {
    self.noResultLabel.hidden = YES;
    self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spin.center = self.view.center;
    [self.view addSubview:self.spin];
    [self.spin startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        self.search = [SearchsController getSearchResults:self.searchBar.text];
        [self checkIfIsThereNoResult];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self.spin stopAnimating];
            self.dataLoaded = true;
            [self.tableView reloadData];
        });
    });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return self.search.listOfMusics.count;
            break;
        case 1:
            return self.search.listOfAlbums.count;
            break;
        case 2:
            return self.search.listOfArtists.count;
            break;
        case 3:
            return self.search.listOfUsers.count;
            break;
        case 4:
            return self.search.listOfPacks.count;
            break;
        default:
            break;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
    }
    if (section == 0) {
        return [self.translate.dict objectForKey:@"title_musics"];
    } else if (section == 1) {
        return [self.translate.dict objectForKey:@"title_albums"];
    } else if (section == 2) {
        return [self.translate.dict objectForKey:@"title_artists"];
    } else if (section == 3) {
        return [self.translate.dict objectForKey:@"title_users"];
    }
    
    return [self.translate.dict objectForKey:@"title_packs"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.section == 0) {
        Music *m = [self.search.listOfMusics objectAtIndex:indexPath.row];
        static NSString *cellIdentifier = @"cellMusic";
        
        SearchMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = (SearchMusicTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"SearchMusicTableViewCell" owner:self options:nil] lastObject];
            [cell initCell:m];
            cell.backgroundColor = [UIColor clearColor];
            cell.tag = 0;
        }
       return cell;
    }
    else if (indexPath.section == 1) {
        Album *a = [self.search.listOfAlbums objectAtIndex:indexPath.row];
        static NSString *cellIdentifier = @"cellAlbum";
        
        SearchAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = (SearchAlbumTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"SearchAlbumTableViewCell" owner:self options:nil] lastObject];
            [cell initCell:a];
            cell.backgroundColor = [UIColor clearColor];
            cell.tag = 1;
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/albums/%@", API_URL, a.image];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            cell.albumImage.image = [UIImage imageWithData:imageData];
        }
        return cell;
    }
    else if (indexPath.section == 2) {
        User *a = [self.search.listOfArtists objectAtIndex:indexPath.row];
        static NSString *cellIdentifier = @"cellArtist";
        
        SearchArtistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = (SearchArtistTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"SearchArtistTableViewCell" owner:self options:nil] lastObject];
            [cell initCell:a];
            cell.backgroundColor = [UIColor clearColor];
            cell.tag = 2;
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, a.image];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            cell.artistImage.image = [UIImage imageWithData:imageData];
        }
        return cell;
    } else if (indexPath.section == 3) {
        User *a = [self.search.listOfUsers objectAtIndex:indexPath.row];
        static NSString *cellIdentifier = @"cellUser";
        
        SearchArtistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = (SearchArtistTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"SearchArtistTableViewCell" owner:self options:nil] lastObject];
            [cell initCell:a];
            cell.backgroundColor = [UIColor clearColor];
            cell.tag = 3;
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, a.image];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            cell.artistImage.image = [UIImage imageWithData:imageData];
        }
        return cell;
    }
    
    Pack *a = [self.search.listOfPacks objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"cellPack";
    
    SearchMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = (SearchMusicTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"SearchMusicTableViewCell" owner:self options:nil] lastObject];
        [cell initCell:a];
        cell.backgroundColor = [UIColor clearColor];
        cell.tag = 4;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.tag == 0) {
        Music *music = [self.search.listOfMusics objectAtIndex:indexPath.row];
        Album *album = [[Album alloc] init];
        album.identifier = music.albumId;
        [self.delegate elementClicked:album];
    } else if (cell.tag == 1) {
       [self.delegate elementClicked:[self.search.listOfAlbums objectAtIndex:indexPath.row]];
    } else if (cell.tag == 2) {
        [self.delegate elementClicked:[self.search.listOfArtists objectAtIndex:indexPath.row]];
    } else if (cell.tag == 3) {
        [self.delegate elementClicked:[self.search.listOfUsers objectAtIndex:indexPath.row]];
    } else if (cell.tag == 4) {
        [self.delegate elementClicked:[self.search.listOfPacks objectAtIndex:indexPath.row]];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
}

- (void)checkIfIsThereNoResult {
    if (self.search.listOfAlbums.count > 0 || self.search.listOfArtists.count > 0 || self.search.listOfMusics > 0 || self.search.listOfUsers > 0 || self.search.listOfPacks > 0) {
        self.noResultLabel.hidden = YES;
        self.tableView.hidden = NO;
    } else {
        self.noResultLabel.hidden = NO;
        [self.tableView setHidden:YES];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.tableData.count == 0) {
        self.tableView.hidden = YES;
        self.noResultLabel.hidden = NO;
    }
    [searchBar resignFirstResponder];
    //self.dataLoaded = NO;
    [self getData];
}

@end
