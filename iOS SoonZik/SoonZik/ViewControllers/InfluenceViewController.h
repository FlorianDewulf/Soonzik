//
//  InfluenceViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 11/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TypeViewController.h"
#import "Influence.h"

@interface InfluenceViewController : TypeViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Influence *influence;
@property (nonatomic, strong) UITableView *tableView;

@end
