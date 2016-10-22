//
//  SearchViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 23/02/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Translate.h"
#import "Search.h"

@protocol SearchElementInterface <NSObject>

- (void)elementClicked:(id)elem;

@end

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UILabel *noResultLabel;
@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) Search *search;
@property (strong, nonatomic) id<SearchElementInterface>delegate;
@property (strong, nonatomic) Translate *translate;

@property (nonatomic, assign) bool dataLoaded;
@property (nonatomic, strong) UIActivityIndicatorView *spin;

@end
