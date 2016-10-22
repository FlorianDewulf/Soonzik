//
//  ArtistViewController.m
//  SoonZik
//
//  Created by LLC on 04/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ArtistViewController.h"
#import "Album.h"
#import "SVGKImage.h"
#import "Tools.h"
#import "TitleAlbumsTableViewCell.h"
#import "AlbumViewController.h"
#import "SimplePopUp.h"
#import "UsersController.h"
#import "TweetsController.h"
#import "Tweet.h"

@interface ArtistViewController ()

@end

@implementation ArtistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 4, 36, 36)];
    [closeButton setImage:[SVGKImage imageNamed:@"delete"].UIImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    if (self.fromNav) {
        closeButton.hidden = true;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationController.navigationBarHidden = false;
        [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
    }
    else if (self.fromSearch) {
        closeButton.hidden = true;
        self.navigationController.navigationBarHidden = false;
        [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
    } else if (self.fromCurrentList) {
        closeButton.hidden = false;
        self.navigationController.navigationBarHidden = false;
        [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    self.user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.dataLoaded = NO;
    [self getData];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.shareButton addTarget:self action:@selector(launchShareView) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"share"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];

    [self.followButton addTarget:self action:@selector(followPeople) forControlEvents:UIControlEventTouchUpInside];
    [self.friendButton addTarget:self action:@selector(friendAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.artistImage.layer.borderWidth = 1;
    self.artistImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.artistName.text = self.artist.username;
    
    NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, self.artist.image];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
    self.artistImage.image = [UIImage imageWithData:imageData];
    self.visualEffectView.backgroundColor = [UIColor colorWithPatternImage:self.artistImage.image];
}

- (void)getData {
    self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spin.center = self.view.center;
    [self.view addSubview:self.spin];
    [self.spin startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        self.listOfAlbums = [Factory findElementWithClassName:@"Album" andValues:[NSString stringWithFormat:@"attribute[user_id]=%i", self.artist.identifier]];
        self.listOfTweets = [TweetsController getTweets:self.artist.identifier];
        
        NSMutableArray *listOfFollows = [UsersController getFollows :self.user.identifier];
        for (User *artist in listOfFollows) {
            if (artist.identifier == self.artist.identifier) {
                self.followed = true;
            }
        }
        for (User *friend in self.user.friends) {
            if (friend.identifier == self.artist.identifier) {
                self.isFriend = true;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self.spin stopAnimating];
            self.dataLoaded = true;
            if (self.followed) {
                [self.followButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"follow_1"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
            } else {
                [self.followButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"follow_0"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
            }
            
            if (self.isFriend) {
                [self.friendButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"people_followed"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
            } else {
                [self.friendButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"people"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
            }
            [self.tableView reloadData];
        });
    });
}

- (void)followPeople {
    if (self.followed) {
        if ([UsersController unfollow:self.artist.identifier]) {
            [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"unfollow_artist"], self.artist.username] onView:self.view withSuccess:true] show];
            [self.followButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"follow_0"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
            self.followed = false;
        } else {
            [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"playlist_deleted_error"], self.artist.username] onView:self.view withSuccess:false] show];
        }
    } else {
        if ([UsersController follow:self.artist.identifier]) {
            [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"follow_artist"], self.artist.username] onView:self.view withSuccess:true] show];
            [self.followButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"follow_1"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
            self.followed = true;
        } else {
            [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"playlist_deleted_error"], self.artist.username] onView:self.view withSuccess:false] show];
        }
    }
}

- (void)friendAction {
    if (self.isFriend) {
        if ([UsersController delFriend:self.artist.identifier]) {
            for (int i =0; i<self.user.friends.count; i++) {
                User *friend = [self.user.friends objectAtIndex:i];
                if (friend.identifier == self.artist.identifier) {
                    [self.user.friends removeObjectAtIndex:i];
                }
            }
            NSData *dataStore = [NSKeyedArchiver archivedDataWithRootObject:self.user];
            [[NSUserDefaults standardUserDefaults] setObject:dataStore forKey:@"User"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"del_friend"], self.artist.username] onView:self.view withSuccess:true] show];
            [self.friendButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"people"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
            self.isFriend = false;
        } else {
            [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"playlist_deleted_error"], self.artist.username] onView:self.view withSuccess:false] show];
        }
    } else {
        if ([UsersController addFriend:self.artist.identifier]) {
            [self.user.friends addObject:self.artist];
            NSData *dataStore = [NSKeyedArchiver archivedDataWithRootObject:self.user];
            [[NSUserDefaults standardUserDefaults] setObject:dataStore forKey:@"User"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"add_friend"], self.artist.username] onView:self.view withSuccess:true] show];
            [self.friendButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"people_followed"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
            self.isFriend = true;
        } else {
            [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:[self.translate.dict objectForKey:@"playlist_deleted_error"], self.artist.username] onView:self.view withSuccess:false] show];
        }
    }
}

- (void)launchShareView
{
    [super launchShareView:self.artist];
}

- (void)closeView {
    [self.shareView removeFromSuperview];
    [self removeBlurEffect:200 onView:self.view];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.listOfAlbums.count;
    } else if (section == 1) {
        return 4;
    }
    
    return self.listOfTweets.count;
   }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 60;
    }
    
    return 0;
}*/

/*- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
        self.textView.textColor = [UIColor whiteColor];
        [self.textView setBackgroundColor:DARK_GREY];
        self.textView.layer.cornerRadius = 0.5f;
        self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.textView.layer.borderWidth = 1;
        [view addSubview:self.textView];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width-80-5, self.textView.frame.size.height, 80, 20)];
        [btn addTarget:self action:@selector(sendTweet) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"Envoyer" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:btn];
        view.backgroundColor = DARK_GREY;
        return view;
    }
    
    return nil;
}*/

- (void)sendTweet {
    if ([TweetsController sendTweet:self.textView.text]) {
        [[[SimplePopUp alloc] initWithMessage:[NSString stringWithFormat:@"Tweet envoyé à %@", self.artist.username] onView:self.view withSuccess:true] show];
    } else {
        [[[SimplePopUp alloc] initWithMessage:@"Erreur lors de l'envoi du tweet" onView:self.view withSuccess:false] show];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        // albums
        return [self.translate.dict objectForKey:@"title_albums"];
    } else if (section == 1) {
        // titres
        return [self.translate.dict objectForKey:@"title_musics"];
    }
    // social
    return [self.translate.dict objectForKey:@"title_social"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"cellId";
        
        TitleAlbumsTableViewCell *cell = (TitleAlbumsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"TitleAlbumsTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        }
        
        Album *album = [self.listOfAlbums objectAtIndex:indexPath.row];
        
        NSString *urlImage = [NSString stringWithFormat:@"%@assets/albums/%@", API_URL, album.image];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
        cell.albumImage.image = [UIImage imageWithData:imageData];
        
        cell.albumTitle.text = album.title;
        cell.albumArtist.text = album.artist.username;
        cell.backgroundColor = DARK_GREY;
        
        return cell;
    
    } else if (indexPath.section == 1) {
        static NSString *cellIdentifier = @"cellId2";
        
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        //cell.artistImage.image = [UIImage imageNamed:@"artist2.jpg"];
        //cell.artistName.text = @"artist 2";
        cell.backgroundColor = DARK_GREY;
        return cell;
    }
    
    static NSString *cellIdentifier = @"cellId3";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = DARK_GREY;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    Tweet *tweet = [self.listOfTweets objectAtIndex:indexPath.row];
    
    cell.textLabel.text = tweet.msg;
    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitHour;
    NSDateComponents *conversionInfo = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] components:unitFlags fromDate:tweet.date   toDate:[NSDate date]  options:0];
    
    int seconds = [conversionInfo second];
    int days = [conversionInfo day];
    int hours = [conversionInfo hour];
    int minutes = [conversionInfo minute];
    
    if (days < 1) {
        if (hours < 1) {
            if (minutes < 1) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Il y a %i secondes", seconds];
            } else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"Il y a %i minutes", minutes];
            }
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Il y a %i heures", hours];
        }
    } else if (days == 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Il y a %i jour", 1];
    } else if (days > 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Il y a %i jours", days];
    }

    cell.textLabel.font = SOONZIK_FONT_BODY_SMALL;
    cell.detailTextLabel.font = SOONZIK_FONT_BODY_VERY_SMALL;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    [cell sizeToFit];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Album *album = [self.listOfAlbums objectAtIndex:indexPath.row];
        
        [self closePopUp];
        
        AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
        vc.album = album;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}

@end
