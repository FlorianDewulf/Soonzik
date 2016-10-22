//
//  PackDetailViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TypeViewController.h"
#import "Pack.h"

@interface PackDetailViewController : TypeViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) Pack *pack;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, assign) bool fromSearch;
@property (nonatomic, assign) bool fromPack;
@property (nonatomic, assign) float avg;
@property (nonatomic, assign) float price;

@property (nonatomic, assign) bool dataLoaded;
@property (nonatomic, strong) UIActivityIndicatorView *spin;

@end
