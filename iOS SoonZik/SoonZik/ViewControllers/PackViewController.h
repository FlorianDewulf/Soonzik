//
//  PackViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 08/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"
#import "HeaderPackView.h"

@interface PackViewController : TypeViewController <SlidePacksDelegate>

@property (nonatomic, strong) NSArray *listOfPacks;
@property (nonatomic, strong) IBOutlet UILabel *packLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) IBOutlet UIView *blurView;
@property (nonatomic, strong) CALayer *subLayer;
@property (nonatomic, assign) int indexOfPage;

@property (nonatomic, assign) bool dataLoaded;
@property (nonatomic, strong) UIActivityIndicatorView *spin;

@end
