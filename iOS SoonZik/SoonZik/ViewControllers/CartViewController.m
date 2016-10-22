//
//  CartViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 11/08/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "CartViewController.h"
#import "CartController.h"
#import "Album.h"
#import "SVGKImage.h"
#import "CartDeleteButton.h"
#import "SimplePopUp.h"
#import "Tools.h"
#import "AppDelegate.h"

@interface CartViewController ()
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@end

@implementation CartViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = DARK_GREY;
    
    UIImage *menuImage = [Tools imageWithImage:[SVGKImage imageNamed:@"menu"].UIImage scaledToSize:CGSizeMake(30, 30)];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController)];
    menuButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = menuButton;
    
    if (!self.fromMenu) {
        UIImage *searchImage = [Tools imageWithImage:[SVGKImage imageNamed:@"search"].UIImage scaledToSize:CGSizeMake(30, 30)];
        UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController)];
        searchButton.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = searchButton;
        self.navigationItem.leftBarButtonItems = nil;
    }
    
    self.carts = [CartController getCart];
    self.musics = [self getMusics];
    self.albums = [self getAlbums];
    
    if (self.musics.count == 0 && self.albums.count == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height / 2)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = @"Votre panier est vide";
        label.font = SOONZIK_FONT_BODY_BIG;
        [self.view addSubview:label];
        [self.tableView removeFromSuperview];
    }
    
    [self initPayPal];
}

- (void)initPayPal {
    _payPalConfiguration = [[PayPalConfiguration alloc] init];
    _payPalConfiguration.acceptCreditCards = NO;
    _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
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
        [CartController buyCart:identifier];
    }
}

- (void)presentRightMenuViewController {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.revealController showRightViewController];
}

- (void)presentLeftMenuViewController {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.revealController showLeftViewController];
}

- (void)closeViewController {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.albums.count > 0) {
            return 70;
        } else if (self.musics.count > 0) {
            return 70;
        }
    } else if (indexPath.section == 1 && ([self getNumberOfSections] != 1)) {
        if (self.musics.count > 0) {
            return 70;
        } else {
            return 44;
        }
    }
    
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self getNumberOfSections]+2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   if (section == 0) {
        if (self.albums.count > 0) {
            // ALBUM
            return self.albums.count;
        } else if (self.musics.count > 0) {
            // MUSIC
            return self.musics.count;
        }
   } else if (section == 1) {
        if (self.musics.count > 0) {
            // MUSIC
            return self.musics.count;
        } else {
            // TOTAL
            return 1;
        }
    } else if (section == 2) {
        if (self.albums.count > 0 && self.musics.count > 0) {
            // TOTAL
            return 1;
        } else if ([self getNumberOfSections] == 1) {
            // BUY
            return 1;
        }
    } else if (section == 3) {
        // BUY
        return 1;
    }
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.albums.count > 0) {
            // ALBUM
            return @"Albums";
        } else if (self.musics.count > 0) {
            // MUSIC
            return @"Musics";
        }
    } else if (section == 1) {
        if (self.musics.count > 0) {
            // MUSIC
            return @"Musics";
        } else {
            // TOTAL
            return @"";
        }
    } else if (section == 2) {
        if (self.albums.count > 0 && self.musics.count > 0) {
            // TOTAL
            return @"";
        } else if ([self getNumberOfSections] == 1) {
            // BUY
            return @"";
        }
    } else if (section == 3) {
        // BUY
        return @"";
    }
    
    return @"";
}

- (int)getNumberOfSections {
    int cpt = 0;
    if (self.albums.count > 0)
        cpt++;
    if (self.musics.count > 0)
        cpt++;
    
    return cpt;
}

- (float)getTotalPrice {
    float price = 0;
    for (Cart *cart in self.albums) {
        Album *album = [cart.albums firstObject];
        price += album.price;
    }
    for (Cart *cart in self.musics) {
        Music *music = [cart.musics firstObject];
        price += music.price;
    }
    
    return price;
}

- (NSMutableArray *)getAlbums {
    NSMutableArray *albums = [NSMutableArray new];
    for (Cart *cart in self.carts) {
        if (cart.type == 1) {
            [albums addObject:cart];
        }
    }
    
    return albums;
}

- (NSMutableArray *)getMusics {
    NSMutableArray *musics = [NSMutableArray new];
    for (Cart *cart in self.carts) {
        if (cart.type == 2) {
            [musics addObject:cart];
        }
    }
    
    return musics;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.albums.count > 0) {
            // ALBUM
            CartItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellItem"];
            if (!cell) {
                [self.tableView registerNib:[UINib nibWithNibName:@"CartItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellItem"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"cellItem"];
            }
            Cart *cart = [self.albums objectAtIndex:indexPath.row];
            Album *album = [cart.albums firstObject];
            cell.titleLabel.text = album.title;
            cell.artistLabel.text = album.artist.username;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.deleteButton setImage:[SVGKImage imageNamed:@"delete"].UIImage forState:UIControlStateNormal];
            [cell.deleteButton addTarget:self action:@selector(deleteCart:) forControlEvents:UIControlEventTouchUpInside];
            cell.deleteButton.cart = cart;
            cell.titleLabel.textColor = [UIColor whiteColor];
            cell.artistLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor clearColor];
            
            return cell;
        } else if (self.musics.count > 0) {
            // MUSIC
            CartItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellItem"];
            if (!cell) {
                [self.tableView registerNib:[UINib nibWithNibName:@"CartItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellItem"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"cellItem"];
            }
            Cart *cart = [self.musics objectAtIndex:indexPath.row];
            Music *music = [cart.musics firstObject];
            cell.titleLabel.text = music.title;
            cell.artistLabel.text = music.artist.username;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.deleteButton setImage:[SVGKImage imageNamed:@"delete"].UIImage forState:UIControlStateNormal];
            [cell.deleteButton addTarget:self action:@selector(deleteCart:) forControlEvents:UIControlEventTouchUpInside];
            cell.deleteButton.cart = cart;
            cell.titleLabel.textColor = [UIColor whiteColor];
            cell.artistLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
    } else if (indexPath.section == 1) {
        if (self.musics.count > 0) {
            // MUSIC
            CartItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellItem"];
            if (!cell) {
                [self.tableView registerNib:[UINib nibWithNibName:@"CartItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellItem"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"cellItem"];
            }
            Cart *cart = [self.musics objectAtIndex:indexPath.row];
            Music *music = [cart.musics firstObject];
            cell.titleLabel.text = music.title;
            cell.artistLabel.text = music.artist.username;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.deleteButton setImage:[SVGKImage imageNamed:@"delete"].UIImage forState:UIControlStateNormal];
            [cell.deleteButton addTarget:self action:@selector(deleteCart:) forControlEvents:UIControlEventTouchUpInside];
            cell.deleteButton.cart = cart;
            cell.titleLabel.textColor = [UIColor whiteColor];
            cell.artistLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        } else {
            // TOTAL
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTotal"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTotal"];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"%.1f €", [self getTotalPrice]];
            cell.textLabel.font = SOONZIK_FONT_BODY_MEDIUM;
            cell.textLabel.textAlignment = NSTextAlignmentRight;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            cell.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            return cell;
        }
    } else if (indexPath.section == 2) {
        if (self.albums.count > 0 && self.musics.count > 0) {
            // TOTAL
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTotal"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTotal"];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"%.1f €", [self getTotalPrice]];
            cell.textLabel.font = SOONZIK_FONT_BODY_MEDIUM;
            cell.textLabel.textAlignment = NSTextAlignmentRight;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            cell.backgroundColor = [UIColor clearColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            return cell;
        } else if ([self getNumberOfSections] == 1) {
            // BUY
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellButton"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellButton"];
            }
            UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, cell.frame.size.width - 40, cell.frame.size.height)];
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
            
            [cell.contentView addSubview:buttonView];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    // BUY
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellButton"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellButton"];
    }
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, cell.frame.size.width - 40, cell.frame.size.height)];
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
    
    [cell.contentView addSubview:buttonView];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)deleteCart:(CartDeleteButton *)button {
    if ([CartController removeCart:button.cart.identifier]) {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"cart_success_delete"] onView:self.view withSuccess:true] show];
        self.carts = [CartController getCart];
        self.musics = [self getMusics];
        self.albums = [self getAlbums];
        [self checkCells];
        [self.tableView reloadData];
        
        if (self.musics.count == 0 && self.albums.count == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height / 2)];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.text = [self.translate.dict objectForKey:@"cart_empty"];
            label.font = SOONZIK_FONT_BODY_BIG;
            [self.view addSubview:label];
            [self.tableView removeFromSuperview];
        }
    } else {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"cart_error_delete"] onView:self.view withSuccess:false] show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if ([self getNumberOfSections] == 1) {
            [self launchPaypal];
        }
    } else if (indexPath.section == 3) {
        [self launchPaypal];
    }
}

- (void)launchPaypal {
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = [[NSDecimalNumber alloc] initWithFloat:[self getTotalPrice]];
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

- (void)checkCells {
    if ([self getNumberOfSections] == 0){
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

@end
