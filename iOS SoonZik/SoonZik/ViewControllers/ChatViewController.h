//
//  ChatViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 16/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOMessagingViewController.h"
#import "User.h"
#import "Socket.h"

@interface ChatViewController : SOMessagingViewController <MessageReceivedDelegate>

@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) UIImage *partnerImage;
@property (strong, nonatomic) User *friend;
@property (strong, nonatomic) Socket *socket;

@end
