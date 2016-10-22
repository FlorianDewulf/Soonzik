//
//  GiftViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 15/01/16.
//  Copyright © 2016 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol GiftDelegate <NSObject>
- (void)friendSelected:(User *)f;
@end

@interface GiftViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *listOfFriends;

@property (nonatomic, strong) id<GiftDelegate> delegate;


@end
