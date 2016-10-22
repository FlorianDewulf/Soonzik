//
//  TypeViewController.h
//  SoonZik
//
//  Created by devmac on 27/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MenuTabDelegate.h"
#import "AudioPlayer.h"
#import "Music.h"
#import "TitleSongPreview.h"
#import "OnLTMusicPopupView.h"
#import "Tools.h"
#import "ShareView.h"
#import "SocialConnect.h"
#import "Translate.h"
#import "Socket.h"

@interface TypeViewController : UIViewController <FinishPlayPlayer, PopUpDetailMusicDelegate, UIActionSheetDelegate, MessageReceivedDelegate>

@property (nonatomic, strong) NSUserDefaults *prefs;
@property (strong, nonatomic) AudioPlayer *player;
@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong) Translate *translate;


- (void)addBlurEffectOnView:(UIView *)view;
- (void)removeBlurEffect:(int)tag onView:(UIView *)v;
- (void)closeViewController;
- (void)closePopUp;
- (void)launchShareView:(id)elem;


@end
