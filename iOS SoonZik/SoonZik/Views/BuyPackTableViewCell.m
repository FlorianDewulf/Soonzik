//
//  BuyPackTableViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 22/03/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import "BuyPackTableViewCell.h"
#import "Translate.h"

@implementation BuyPackTableViewCell

- (void)initCell
{
    self.buyButton.layer.cornerRadius = 5;
    self.buyButton.backgroundColor = BLUE_1;
    self.backgroundColor = [UIColor clearColor];
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    Translate *translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    [self.buyButton setTitle:[translate.dict objectForKey:@"buy_now"] forState:UIControlStateNormal];
}

@end
