//
//  ExploreViewController.m
//  SoonZik
//
//  Created by LLC on 08/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ExploreViewController.h"
#import "Influence.h"
#import "InfluenceViewController.h"
#import "ConcertsController.h"
#import "Concert.h"
#import "ConcertViewController.h"
#import "SuggestsController.h"
#import "ArtistViewController.h"
#import "AmbiancesController.h"
#import "Ambiance.h"
#import "AmbianceViewController.h"

#define NAVIGATIONBAR_HEIGHT 50

@interface ExploreViewController ()

@end

@implementation ExploreViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataLoaded = NO;
    [self getData];
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];

    [self initNavigationButtons];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = true;
    self.scrollView.scrollEnabled = false;
    self.scrollView.directionalLockEnabled = true;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*4, self.view.frame.size.height)];
    [contentView layoutIfNeeded];
    CGSize size = CGSizeMake(contentView.bounds.size.width, contentView.bounds.size.height);
    self.scrollView.contentSize = size;
    
    UIView *influencesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.influencesTableView = [[UITableView alloc] initWithFrame:influencesView.frame style:UITableViewStyleGrouped];
    self.influencesTableView.delegate = self;
    self.influencesTableView.dataSource = self;
    self.influencesTableView.tag = 1;
    [self.influencesTableView setBackgroundColor:[UIColor clearColor]];
    self.influencesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [influencesView addSubview:self.influencesTableView];
    [contentView addSubview:influencesView];
    
    UIView *musicsView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.artistsTableView = [[UITableView alloc] initWithFrame:influencesView.frame style:UITableViewStyleGrouped];
    self.artistsTableView.delegate = self;
    self.artistsTableView.dataSource = self;
    self.artistsTableView.tag = 2;
    [self.artistsTableView setBackgroundColor:[UIColor clearColor]];
    self.artistsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [musicsView addSubview:self.artistsTableView];
    [contentView addSubview:musicsView];
    
    UIView *concertView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.concertsTableView = [[UITableView alloc] initWithFrame:influencesView.frame style:UITableViewStyleGrouped];
    self.concertsTableView.delegate = self;
    self.concertsTableView.dataSource = self;
    self.concertsTableView.tag = 3;
    [self.concertsTableView setBackgroundColor:[UIColor clearColor]];
    self.concertsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [concertView addSubview:self.concertsTableView];
    [contentView addSubview:concertView];
    
    UIView *ambiancesView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*3, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.ambiancesTableView = [[UITableView alloc] initWithFrame:influencesView.frame style:UITableViewStyleGrouped];
    self.ambiancesTableView.delegate = self;
    self.ambiancesTableView.dataSource = self;
    self.ambiancesTableView.tag = 4;
    [self.ambiancesTableView setBackgroundColor:[UIColor clearColor]];
    self.ambiancesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [ambiancesView addSubview:self.ambiancesTableView];
    [contentView addSubview:ambiancesView];

    
    [self.scrollView addSubview:contentView];
    
    self.view.backgroundColor = DARK_GREY;
    
    [self.view sendSubviewToBack:self.scrollView];
}

- (void)getData {
    self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spin.center = self.view.center;
    [self.view addSubview:self.spin];
    [self.spin startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        self.listOfInfluences = [Factory provideListWithClassName:@"Influence"];
        self.listOfConcerts = [ConcertsController getConcerts];
        self.listOfArtists = [SuggestsController getSuggests:@"artist"];
        self.listOfAmbiances = [AmbiancesController getAmbiances];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self.spin stopAnimating];
            self.dataLoaded = true;
            [self.influencesTableView reloadData];
            [self.concertsTableView reloadData];
            [self.artistsTableView reloadData];
            [self.ambiancesTableView reloadData];
        });
    });
}

- (void)initNavigationButtons {
    UIView *navigationArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, NAVIGATIONBAR_HEIGHT)];
    navigationArea.backgroundColor = DARK_GREY;
    navigationArea.tag = 2000;
    
    UIButton *influencesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/4, navigationArea.frame.size.height)];
    [influencesButton setTitle:[self.translate.dict objectForKey:@"title_influences"] forState:UIControlStateNormal];
    [influencesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [influencesButton addTarget:self action:@selector(moveToTheGoodView:) forControlEvents:UIControlEventTouchUpInside];
    influencesButton.tag = 1;
    [navigationArea addSubview:influencesButton];
    
    UIButton *artistesButton = [[UIButton alloc] initWithFrame:CGRectMake(influencesButton.frame.size.width, 0, influencesButton.frame.size.width, navigationArea.frame.size.height)];
    [artistesButton setTitle:[self.translate.dict objectForKey:@"title_artists"] forState:UIControlStateNormal];
    [artistesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [artistesButton addTarget:self action:@selector(moveToTheGoodView:) forControlEvents:UIControlEventTouchUpInside];
    artistesButton.tag = 2;
    [navigationArea addSubview:artistesButton];
    
    UIButton *concertsButton = [[UIButton alloc] initWithFrame:CGRectMake(influencesButton.frame.size.width*2, 0, influencesButton.frame.size.width, navigationArea.frame.size.height)];
    [concertsButton setTitle:@"Concerts" forState:UIControlStateNormal];
    [concertsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [concertsButton addTarget:self action:@selector(moveToTheGoodView:) forControlEvents:UIControlEventTouchUpInside];
    concertsButton.tag = 3;
    [navigationArea addSubview:concertsButton];
    
    UIButton *ambiancesButton = [[UIButton alloc] initWithFrame:CGRectMake(influencesButton.frame.size.width*3, 0, influencesButton.frame.size.width, navigationArea.frame.size.height)];
    [ambiancesButton setTitle:@"Ambiances" forState:UIControlStateNormal];
    [ambiancesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ambiancesButton addTarget:self action:@selector(moveToTheGoodView:) forControlEvents:UIControlEventTouchUpInside];
    ambiancesButton.tag = 4;
    [navigationArea addSubview:ambiancesButton];
    
    [self.view addSubview:navigationArea];
    [self.view bringSubviewToFront:navigationArea];
    
    [influencesButton setTitleColor:BLUE_1 forState:UIControlStateNormal];
}

- (void)moveToTheGoodView:(UIButton *)btn {
    NSLog(@"move to the right view");
    [self refreshButtonsColor:btn.tag];
    switch (btn.tag) {
        case 1:
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:true];
            break;
        case 2:
            [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:true];
            break;
        case 3:
            [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width*2, 0) animated:true];
            break;
        case 4:
            [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width*3, 0) animated:true];
            break;
        default:
            break;
    }
}

- (void)refreshButtonsColor:(int)tag {
    UIView *navBar = [self.view viewWithTag:2000];
    UIButton *influencesButton = (UIButton *)[navBar viewWithTag:1];
    UIButton *artistsButton = (UIButton *)[navBar viewWithTag:2];
    UIButton *concertsButton = (UIButton *)[navBar viewWithTag:3];
    UIButton *ambiancesButton = (UIButton *)[navBar viewWithTag:4];
    if (tag == 1) {
        [influencesButton setTitleColor:BLUE_1 forState:UIControlStateNormal];
        [artistsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [concertsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ambiancesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else if (tag == 2) {
        [influencesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [artistsButton setTitleColor:BLUE_1 forState:UIControlStateNormal];
        [concertsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ambiancesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else if (tag == 3) {
        [influencesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [artistsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [concertsButton setTitleColor:BLUE_1 forState:UIControlStateNormal];
        [ambiancesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else if (tag == 4) {
        [influencesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [artistsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [concertsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ambiancesButton setTitleColor:BLUE_1 forState:UIControlStateNormal];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataLoaded) {
        if (tableView.tag == 1)
            return self.listOfInfluences.count;
        else if (tableView.tag == 2)
            return self.listOfArtists.count;
        else if (tableView.tag == 3)
            return self.listOfConcerts.count;
        else if (tableView.tag == 4)
            return self.listOfInfluences.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID1"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID1"];
        }
        Influence *influence = [self.listOfInfluences objectAtIndex:indexPath.row];
        cell.textLabel.text = influence.name;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = SOONZIK_FONT_BODY_MEDIUM;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if (tableView.tag == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellConcerts"];
        Concert *concert = [self.listOfConcerts objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", concert.address.city, concert.address.street];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = SOONZIK_FONT_BODY_MEDIUM;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else if (tableView.tag == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID1"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID1"];
        }
        Ambiance *ambiance = [self.listOfAmbiances objectAtIndex:indexPath.row];
        cell.textLabel.text = ambiance.name;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = SOONZIK_FONT_BODY_MEDIUM;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellArtists"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellArtists"];
    }
    User *artist = [self.listOfArtists objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = SOONZIK_FONT_BODY_MEDIUM;
    cell.textLabel.text = artist.username;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        Influence *influence = [self.listOfInfluences objectAtIndex:indexPath.row];
        InfluenceViewController *vc = [[InfluenceViewController alloc] init];
        vc.influence = influence;
        [self.navigationController pushViewController:vc animated:true];
    }
    else if (tableView.tag == 2) {
        User *artist = [self.listOfArtists objectAtIndex:indexPath.row];
        ArtistViewController *vc = [[ArtistViewController alloc] initWithNibName:@"ArtistViewController" bundle:nil];
        vc.artist = artist;
        vc.fromNav = true;
        [self.navigationController pushViewController:vc animated:true];
    }
    else if (tableView.tag == 3) {
        Concert *concert = [self.listOfConcerts objectAtIndex:indexPath.row];
        ConcertViewController *vc = [[ConcertViewController alloc] initWithNibName:@"ConcertViewController" bundle:nil];
        vc.concert = concert;
        [self.navigationController pushViewController:vc animated:true];
    }
    else if (tableView.tag == 4) {
        Ambiance *ambiance = [self.listOfAmbiances objectAtIndex:indexPath.row];
        AmbianceViewController *vc = [[AmbianceViewController alloc] initWithNibName:@"AmbianceViewController" bundle:nil];
        vc.ambiance = ambiance;
        [self.navigationController pushViewController:vc animated:true];
    }
}

@end
