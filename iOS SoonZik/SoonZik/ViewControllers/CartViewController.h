//
//  CartViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 11/08/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TypeViewController.h"
#import "Cart.h"
#import "Translate.h"
#import "CartItemTableViewCell.h"
#import "PayPalMobile.h"

@interface CartViewController : TypeViewController <UITableViewDataSource, UITableViewDelegate, PayPalPaymentDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *carts;
@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong) NSMutableArray *musics;

@property (nonatomic, assign) bool fromMenu;

@end
