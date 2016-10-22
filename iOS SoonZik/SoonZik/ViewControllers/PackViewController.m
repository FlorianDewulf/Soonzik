//
//  PackViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 08/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "PackViewController.h"
#import "Pack.h"
#import "AlbumInPackTableViewCell.h"
#import "AlbumViewController.h"
#import "BuyPackTableViewCell.h"
#import "SimplePopUp.h"
#import "Description.h"
#import "PackDetailViewController.h"

@interface PackViewController ()

@end

@implementation PackViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = DARK_GREY;
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.dataLoaded = NO;
    [self getData];
    
    self.indexOfPage = 0;
}

- (void)getData {
    self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spin.center = self.view.center;
    [self.view addSubview:self.spin];
    [self.spin startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        self.listOfPacks = [Factory provideListWithClassName:@"Pack"];
        if (self.listOfPacks.count == 0) {
            [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"loading_error"] onView:self.view withSuccess:false] show];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            [self.spin stopAnimating];
            self.dataLoaded = true;
            
            HeaderPackView *view = (HeaderPackView *)[[[NSBundle mainBundle] loadNibNamed:@"HeaderPackView" owner:self options:nil] firstObject];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToPackVC)];
            [view addGestureRecognizer:tap];
            
            if (self.listOfPacks.count > 0) {
                
                [view createSliderWithPacks:self.listOfPacks andPage:self.indexOfPage];
                view.slideDelegate = self;
                view.backgroundColor = DARK_GREY;
            }
            
            [self.view addSubview:view];
            
            view.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        });
    });
}

- (void)changeIndex:(int)index {
    self.indexOfPage = index;
}

- (void)goToPackVC {
    Pack *pack = [self.listOfPacks objectAtIndex:self.indexOfPage];
    PackDetailViewController *packVC = [[PackDetailViewController alloc] initWithNibName:@"PackDetailViewController" bundle:nil];
    packVC.pack = pack;
    packVC.fromPack = true;
    [self.navigationController pushViewController:packVC animated:true];
}

@end
