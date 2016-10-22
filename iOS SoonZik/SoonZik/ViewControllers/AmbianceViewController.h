//
//  AmbianceViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 10/01/16.
//  Copyright © 2016 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TypeViewController.h"
#import "Ambiance.h"

@interface AmbianceViewController : TypeViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) Ambiance *ambiance;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *listOfMusics;

@end
