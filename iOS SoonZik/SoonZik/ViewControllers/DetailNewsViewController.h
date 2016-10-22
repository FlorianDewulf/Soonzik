//
//  DetailNewsViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 19/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "Com.h"
#import "Translate.h"

@interface DetailNewsViewController : UITableViewController <UITextViewDelegate>

@property (nonatomic, strong) News *news;
@property (nonatomic, strong) NSMutableArray *listOfComments;
@property (nonatomic, strong) Translate *translate;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, assign) bool dataLoaded;
@property (nonatomic, strong) UIActivityIndicatorView *spin;

@end
