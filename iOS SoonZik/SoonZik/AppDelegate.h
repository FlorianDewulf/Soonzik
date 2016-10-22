//
//  AppDelegate.h
//  SoonZik
//
//  Created by devmac on 21/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AudioPlayer.h"
#import "ConnexionViewController.h"
#import "PKRevealController.h"
#import "AlbumViewController.h"
#import "ArtistViewController.h"
#import "User.h"
#import "Translate.h"
#import "HomeViewController.h"
#import "ExploreViewController.h"
#import "GeolocationViewController.h"
#import "PackViewController.h"
#import "BattlesViewController.h"
#import "ContentViewController.h"
#import "FriendsViewController.h"
#import "AccountViewController.h"
#import "SearchViewController.h"
#import "ContactViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ConnexionViewController *connexionViewController;
@property (strong, nonatomic) NSUserDefaults *prefs;
@property (nonatomic) int type;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Translate *translate;

@property (nonatomic, strong) UINavigationController *homeVC;
@property (nonatomic, strong) UINavigationController *exploreVC;
@property (nonatomic, strong) UINavigationController *geoVC;
@property (nonatomic, strong) UINavigationController *packVC;
@property (nonatomic, strong) UINavigationController *battleVC;
@property (nonatomic, strong) UINavigationController *contentVC;
@property (nonatomic, strong) UINavigationController *friendsVC;
@property (nonatomic, strong) UINavigationController *accountVC;
@property (nonatomic, strong) UINavigationController *cartVC;
@property (nonatomic, strong) SearchViewController *searchVC;
@property (nonatomic, strong) UINavigationController *feedbackVC;

@property (nonatomic, strong, readwrite) PKRevealController *revealController;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)setTypeConnexion:(int)type;
- (void)launchHome;

@end
