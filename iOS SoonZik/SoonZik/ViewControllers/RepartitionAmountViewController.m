//
//  RepartitionAmountViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 02/08/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "RepartitionAmountViewController.h"
#import "RepartionTableViewCell.h"
#import "PacksController.h"
#import "GiftViewController.h"

@interface RepartitionAmountViewController ()
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@end

@implementation RepartitionAmountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = DARK_GREY;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self initializeCells];
    
    [self initPayPal];
    
    self.friendSelected = nil;
}

- (void)initPayPal {
    _payPalConfiguration = [[PayPalConfiguration alloc] init];
    _payPalConfiguration.acceptCreditCards = NO;
    _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
}

- (void)initializeCells {
    self.cells = [NSMutableArray new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RepartionTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    for (int i = 1; i <= 3; i++) {
        RepartionTableViewCell *cell = (RepartionTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = DARK_GREY;
        cell.value.textColor = [UIColor whiteColor];
        
        cell.slider.minimumValue = 0;
        cell.slider.maximumValue = self.price;
        cell.slider.continuous = true;
        
        if (i == 1) {
            cell.slider.value = 0.65 * self.price;
            self.artist = cell.slider.value;
        } else if (i == 2) {
            cell.slider.value = 0.20 * self.price;
            self.association = cell.slider.value;
        } else if (i == 3) {
            cell.slider.value = 0.15 * self.price;
            self.website = cell.slider.value;
        }
        
        cell.slider.tag = i;
        cell.value.text = [NSString stringWithFormat:@"%.2f", cell.slider.value];
        [cell.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        
        [self.cells addObject:cell];
    }
    
    UITableViewCell *cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"b"];
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, cell2.frame.size.width - 40, cell2.frame.size.height)];
    buttonView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    buttonView.layer.borderWidth = 1;
    buttonView.layer.cornerRadius = 10;
    buttonView.layer.backgroundColor = BLUE_1.CGColor;
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, buttonView.frame.size.width, buttonView.frame.size.height)];
    text.text = [self.translate.dict objectForKey:@"buy_now"];
    text.textAlignment = NSTextAlignmentCenter;
    text.font = SOONZIK_FONT_BODY_MEDIUM;
    text.textColor = [UIColor whiteColor];
    
    [buttonView addSubview:text];
    
    [cell2.contentView addSubview:buttonView];
    
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    cell2.backgroundColor = [UIColor clearColor];
    
    [self.cells addObject:cell2];

}

- (void)buyPack {
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithFloat:self.price];
    payment.currencyCode = @"EUR";
    payment.shortDescription = @"Soonzik transaction";
    payment.intent = PayPalPaymentIntentSale;
    
    if (!payment.processable) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
    }
    
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                   configuration:self.payPalConfiguration
                                                                        delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self verifyCompletedPayment:completedPayment];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    NSDictionary *json = completedPayment.confirmation;
    NSDictionary *response = [json objectForKey:@"response"];
    NSString *identifier = nil;
    if ([[response objectForKey:@"state"] isEqualToString:@"approved"]) {
        [self.navigationController popToRootViewControllerAnimated:true];
        identifier = [response objectForKey:@"id"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[self.translate.dict objectForKey:@"payment_title_success"] message:[self.translate.dict objectForKey:@"payment_message_success"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertView show];
        NSLog(@"self.artist : %.2f", self.artist);
        NSLog(@"self.association : %.2f", self.association);
        NSLog(@"self.website : %.2f", self.website);
        if (self.friendSelected == nil) {
            [PacksController buyPack:self.packID amount:self.price artist:self.artist association:self.association website:self.website withPayPalInfos:completedPayment];
        } else {
            [PacksController buyPack:self.packID amount:self.price artist:self.artist association:self.association website:self.website friendID:self.friendSelected.identifier withPayPalInfos:completedPayment];
        }
        
    }
}

#pragma mark - TableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [self.translate.dict objectForKey:@"repartition_artist"];
    } else if (section == 1) {
        return[self.translate.dict objectForKey:@"repartition_association"];
    } else if (section == 2) {
        return [self.translate.dict objectForKey:@"repartition_site"];
    } else if (section == 4) {
        return @"Send as a gift to a friend";
    }
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellCCC"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellCCC"];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor clearColor];
        }
        
        if (self.friendSelected != nil) {
            cell.textLabel.text = self.friendSelected.username;
        }
        
        return cell;
    }
    return [self.cells objectAtIndex:indexPath.section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        [self buyPack];
    }
    if (indexPath.section == 4) {
        [self gift];
    }
}

- (void)gift {
    GiftViewController *vc = [[GiftViewController alloc] initWithNibName:@"GiftViewController" bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)friendSelected:(User *)f {
    self.friendSelected = f;
    [self.tableView reloadData];
}

- (void)sliderChanged:(UISlider *)slider {
    RepartionTableViewCell *cell1 = [self.cells objectAtIndex:0];
    RepartionTableViewCell *cell2 = [self.cells objectAtIndex:1];
    RepartionTableViewCell *cell3 = [self.cells objectAtIndex:2];
    
    if (slider.tag == 1) {
        cell2.slider.value = (self.price - cell1.slider.value) * 0.60;
        cell3.slider.value = (self.price - cell1.slider.value) * 0.40;
    } else if (slider.tag == 2) {
        cell3.slider.value = (self.price - cell1.slider.value - cell2.slider.value);
    } else if (slider.tag == 3) {
        cell2.slider.value = (self.price - cell3.slider.value - cell1.slider.value);
    }
    
    cell1.value.text = [NSString stringWithFormat:@"%.2f", cell1.slider.value];
    cell2.value.text = [NSString stringWithFormat:@"%.2f", cell2.slider.value];
    cell3.value.text = [NSString stringWithFormat:@"%.2f", cell3.slider.value];
    
    self.artist = cell1.slider.value;
    self.association = cell2.slider.value;
    self.website = cell3.slider.value;
}

- (NSArray *)getCells {
    return @[[self.cells objectAtIndex:1], [self.cells objectAtIndex:2], [self.cells objectAtIndex:3]];
}

@end
