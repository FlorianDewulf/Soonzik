//
//  RepartitionAmountViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 02/08/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Translate.h"
#import "PayPalMobile.h"
#import "User.h"
#import "GiftViewController.h"

@interface RepartitionAmountViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PayPalPaymentDelegate, GiftDelegate>

@property (nonatomic, assign) float price;
@property (nonatomic, assign) int packID;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Translate *translate;

@property (nonatomic, assign) float artist;
@property (nonatomic, assign) float association;
@property (nonatomic, assign) float website;

@property (nonatomic, assign) float pourcentLeft;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *cells;

@property (nonatomic, strong) User *friendSelected;

@end
