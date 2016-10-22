//
//  ConcertViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 01/09/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TypeViewController.h"
#import "Concert.h"

@interface ConcertViewController : TypeViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Concert *concert;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *listOfTexts;

@end
