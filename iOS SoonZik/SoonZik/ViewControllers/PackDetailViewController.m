//
//  PackDetailViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "PackDetailViewController.h"
#import "AlbumInPackTableViewCell.h"
#import "SVGKImage.h"
#import "HeaderPackDetailView.h"
#import "Description.h"
#import "PacksController.h"
#import "RepartitionAmountViewController.h"
#import "AlbumViewController.h"
#import "BuyPackValueTableViewCell.h"

@interface PackDetailViewController ()

@end

@implementation PackDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view.backgroundColor = DARK_GREY;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"BuyPackValueTableViewCell" bundle:nil] forCellReuseIdentifier:@"valueCell"];
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.dataLoaded = false;
    [self getData];
    
    self.price = self.pack.avgPrice;
    
    [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 4, 36, 36)];
    [closeButton setImage:[SVGKImage imageNamed:@"delete"].UIImage forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
   if (self.fromSearch) {
        closeButton.hidden = true;
        self.navigationController.navigationBarHidden = false;
        [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
   } else if (self.fromPack) {
       closeButton.hidden = true;
       self.navigationController.navigationBarHidden = false;
       self.navigationItem.leftBarButtonItem = nil;
       [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationFade];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)getData {
    self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spin.center = self.view.center;
    [self.view addSubview:self.spin];
    [self.spin startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        self.pack = [PacksController getPack:self.pack.identifier];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self.spin stopAnimating];
            self.dataLoaded = true;
            [self.tableView reloadData];
        });
    });
}


#pragma mark UITABLEVIEW DELEGATE METHODS

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataLoaded) {
        if (section == 0)
            return 320;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataLoaded) {
        if (indexPath.section == 0) {
            return 50;
        }
        return 44;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        HeaderPackDetailView *view = (HeaderPackDetailView *)[[[NSBundle mainBundle] loadNibNamed:@"HeaderPackDetailView" owner:self options:nil] firstObject];
        [view initHeader:self.pack];
        return view;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataLoaded) {
        return 5;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataLoaded) {
        if (section == 0) {
            return self.pack.listOfAlbums.count;
        } else if (section == 1) {
            return self.pack.listOfDescriptions.count;
        } else if (section == 2) {
            return 1;
        } else if (section == 3) {
            return 1;
        } else if (section == 4) {
            return 1;
        }
        
    }
   
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Album *album = [self.pack.listOfAlbums objectAtIndex:indexPath.row];
        AlbumInPackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellAlbum"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"AlbumInPackTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellAlbum"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"cellAlbum"];
        }
        cell.albumLabel.text = album.title;
        cell.artistLabel.text = album.artist.username;
        cell.albumLabel.textColor = [UIColor whiteColor];
        cell.artistLabel.textColor = [UIColor whiteColor];
        
        NSLog(@"self.price : %f", self.price);
        NSLog(@"self.pack.avgPrice : %f", self.pack.avgPrice);
        
        if (self.price < self.pack.avgPrice) {
            for (NSNumber *iden in self.pack.partialAlbums) {
                if ([iden intValue] == album.identifier) {
                    cell.albumLabel.textColor = [UIColor blackColor];
                    cell.artistLabel.textColor = [UIColor blackColor];
                }
            }
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1) {
        Description *description = [self.pack.listOfDescriptions objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDescription"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellDescription"];
        }
        cell.textLabel.text = description.text;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = SOONZIK_FONT_BODY_SMALL;
        cell.textLabel.textColor = [UIColor whiteColor];
        return cell;
    } else if (indexPath.section == 2) {
        BuyPackValueTableViewCell *cell = (BuyPackValueTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"valueCell"];
        cell.textField.placeholder = [self.translate.dict objectForKey:@"choose_amount"];
        cell.textField.delegate = self;
        cell.textField.text = [NSString stringWithFormat:@"%.2f", self.price];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    } else if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellPurchase"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellPurchase"];
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellAvg"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellAvg"];
    }
    cell.textLabel.text = [NSString stringWithFormat:[self.translate.dict objectForKey:@"pack_average"], self.pack.avgPrice];
    cell.textLabel.font = SOONZIK_FONT_BODY_MEDIUM;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = [self.translate.dict objectForKey:@"pack_average_message"];
    cell.detailTextLabel.font = SOONZIK_FONT_BODY_SMALL;
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.textColor = ORANGE;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Select %i", indexPath.section);
    if (indexPath.section == 3) {
        RepartitionAmountViewController *vc = [[RepartitionAmountViewController alloc] initWithNibName:@"RepartitionAmountViewController" bundle:nil];
        vc.price = self.price;
        vc.packID = self.pack.identifier;
        [self.navigationController pushViewController:vc animated:true];
    } else if (indexPath.section == 0) {
        AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
        vc.album = [self.pack.listOfAlbums objectAtIndex:indexPath.row];
        vc.fromPack = true;
        [self.navigationController pushViewController:vc animated:true];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"";
    } else if (section == 1) {
        return @"";
    } else if (section == 2) {
        return [self.translate.dict objectForKey:@"repartition_choice"];
    }
    
    return nil;
}

/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"replacement string : %@", string);
    NSLog(@"textfield.text : %@", textField.text);
    if (textField.text.length == 1 && [string isEqualToString:@""]) {
        self.price = 0;
    }
    else if ([string isEqualToString:@""]) {
        NSString *after = [textField.text substringToIndex:[textField.text length]-1];
        //textField.text = after;
        self.price = after.floatValue;
    } else {
        NSString *before = textField.text;
        NSString *after = [NSString stringWithFormat:@"%@%@", before, string];
        //textField.text = after;
        self.price = after.floatValue;
    }
   
    [self checkPrice];
    return true;
}*/

- (void)checkPrice {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    if (self.price == 0) {
        cell.userInteractionEnabled = false;
        cell.alpha = 0.2;
    } else {
        cell.userInteractionEnabled = true;
        cell.alpha = 1;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
     //   [self.tableView reloadData];
    
    //
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.price = textField.text.floatValue;
    [self checkPrice];
    
    BuyPackValueTableViewCell *cell = (BuyPackValueTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    [cell.textField resignFirstResponder];
    return true;
}

@end
