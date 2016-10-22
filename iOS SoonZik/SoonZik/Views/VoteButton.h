//
//  VoteButton.h
//  SoonZik
//
//  Created by Maxime Sauvage on 02/03/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol VoteDelegate <NSObject>
- (void)vote:(User *)artist;
@end

@interface VoteButton : UIButton

@property (nonatomic, strong) IBOutlet UIVisualEffectView *visualEffect;
@property (nonatomic, strong) IBOutlet UIImageView *image;
@property (nonatomic, strong) IBOutlet UILabel *title;

@property (nonatomic, strong) User *artist;

@property (nonatomic, assign) id<VoteDelegate> voteDelegate;

- (void)initButton:(User *)artist;

@end
