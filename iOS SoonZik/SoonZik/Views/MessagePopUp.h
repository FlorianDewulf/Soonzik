//
//  MessagePopUp.h
//  SoonZik
//
//  Created by Maxime Sauvage on 03/10/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessagePopUp : UIView

- (void)initView;

@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;

@end
