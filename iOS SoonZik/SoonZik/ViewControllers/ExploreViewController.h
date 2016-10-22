//
//  ExploreViewController.h
//  SoonZik
//
//  Created by LLC on 08/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"

@interface ExploreViewController : TypeViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *influencesTableView;
@property (nonatomic, strong) UITableView *artistsTableView;
@property (nonatomic, strong) UITableView *concertsTableView;
@property (nonatomic, strong) UITableView *ambiancesTableView;
@property (nonatomic, strong) NSArray *listOfInfluences;
@property (nonatomic, strong) NSArray *listOfConcerts;
@property (nonatomic, strong) NSArray *listOfArtists;
@property (nonatomic, strong) NSArray *listOfAmbiances;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) bool dataLoaded;
@property (nonatomic, strong) UIActivityIndicatorView *spin;

@end

@interface CustomLabel : UILabel

@end