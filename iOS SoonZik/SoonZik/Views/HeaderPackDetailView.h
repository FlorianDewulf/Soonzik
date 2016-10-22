//
//  HeaderPackDetailView.h
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pack.h"

@interface HeaderPackDetailView : UIView

@property (nonatomic, strong) UIImageView *packImage;
@property (nonatomic, strong) IBOutlet UILabel *packLabel;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) int index;

- (void)initHeader:(Pack *)pack;

@end
