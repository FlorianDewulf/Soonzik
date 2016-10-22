//
//  ConcertHeaderView.h
//  SoonZik
//
//  Created by Maxime Sauvage on 05/11/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Concert.h"

@interface ConcertHeaderView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *imgV;
@property (nonatomic, strong) IBOutlet UILabel *artistLabel;
@property (nonatomic, strong) IBOutlet UIButton *artistButton;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;

- (void)initHeader:(Concert *)concert;

@end
