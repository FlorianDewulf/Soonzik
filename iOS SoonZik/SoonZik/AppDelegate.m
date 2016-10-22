//
//  AppDelegate.m
//  SoonZik
//
//  Created by devmac on 21/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "AppDelegate.h"
#import "ConnexionViewController.h"
#import "HomeViewController.h"
#import "SocialConnect.h"
#import "SearchViewController.h"
#import "PackDetailViewController.h"
#import "SVGKImage.h"
#import "Tools.h"
#import "Pack.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <GooglePlus/GPPURLHandler.h>
#import "Translate.h"
#import "UsersController.h"
#import "UserViewController.h"
#import "CartViewController.h"
#import "IdenticationsController.h"
#import "Socket.h"
#import "PayPalMobile.h"
#import "MenuTableViewCell.h"

@interface AppDelegate() <PKRevealing, UITableViewDataSource, UITableViewDelegate, SearchElementInterface>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    self.user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
   // if (translateData == nil) {
        [self getTranslationFile];
   // }
    
    [self initializeMenuSystem];
    [self initBasicGraphics];
    
    [[Twitter sharedInstance] startWithConsumerKey:@"ooWEcrlhooUKVOxSgsVNDJ1RK" consumerSecret:@"BtLpq9ZlFzXrFklC2f1CXqy8EsSzgRRVPZrKVh0imI2TOrZAan"];
    [Fabric with:@[[Twitter sharedInstance]]];
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AfCwBQSyxx6Ys2fnbB_1AmmuINiAPaGlGtk38vTZTCbcevPBIU0Ptt4TgvjNznxkLbSi9fdiaJxG8-u-",
                                                           PayPalEnvironmentSandbox : @"AfCwBQSyxx6Ys2fnbB_1AmmuINiAPaGlGtk38vTZTCbcevPBIU0Ptt4TgvjNznxkLbSi9fdiaJxG8-u-"}];
    
    NSLog(@"self.user.identifier : %i", self.user.identifier);
    
    if (self.user.identifier != 0) {
        [self launchHome];
    } else {
       [self launchConnexion];
    }
    
    return YES;
}

- (void)initializeMenuSystem {
    self.homeVC = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil]];
    self.exploreVC = [[UINavigationController alloc] initWithRootViewController:[[ExploreViewController alloc] initWithNibName:@"ExploreViewController" bundle:nil]];
    self.packVC = [[UINavigationController alloc] initWithRootViewController:[[PackViewController alloc] initWithNibName:@"PackViewController" bundle:nil]];
    self.geoVC = [[UINavigationController alloc] initWithRootViewController:[[GeolocationViewController alloc] initWithNibName:@"GeolocationViewController" bundle:nil]];
    self.accountVC = [[UINavigationController alloc] initWithRootViewController:[[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil]];
    
    self.friendsVC = [[UINavigationController alloc] initWithRootViewController:[[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil]];
    self.battleVC = [[UINavigationController alloc] initWithRootViewController:[[BattlesViewController alloc] init]];
    self.contentVC = [[UINavigationController alloc] initWithRootViewController:[[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil]];
    CartViewController *cart = [[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil];
    cart.fromMenu = true;
    self.cartVC = [[UINavigationController alloc] initWithRootViewController:cart];
    
    ContactViewController *contact = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
    self.feedbackVC = [[UINavigationController alloc] initWithRootViewController:contact];
    
    UINavigationController *frontNavigationController = self.homeVC;
    self.searchVC = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    self.searchVC.delegate = self;
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:frontNavigationController
                                                                     leftViewController:[self leftViewController]
                                                                    rightViewController:self.searchVC];
    self.revealController.delegate = self;
    self.revealController.animationDuration = 0.25;
}

- (void)getTranslationFile {
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSArray *data = [language componentsSeparatedByString:@"-"];
    NSString *path;
    if ([data[0] isEqualToString:@"en"]) {
        path = [[NSBundle mainBundle] pathForResource:@"TR_English" ofType:@"plist"];
    } else if ([data[0] isEqualToString:@"fr"]) {
        path = [[NSBundle mainBundle] pathForResource:@"TR_French" ofType:@"plist"];
    }
    
    self.translate = [[Translate alloc] initWithPath:path];
    
    NSData *dataStore = [NSKeyedArchiver archivedDataWithRootObject:self.translate];
    [[NSUserDefaults standardUserDefaults] setObject:dataStore forKey:@"Translate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) initBasicGraphics {
    UIColor *barColour = DARK_GREY;
    UIView *colourView = [[UIView alloc] initWithFrame:CGRectMake(0.f, -20.f, 320.f, 64.f)];
    colourView.opaque = NO;
    colourView.alpha = .1f;
    colourView.backgroundColor = barColour;
    [[UINavigationBar appearance] setBarTintColor:barColour];
    [[[UINavigationBar appearance] layer] insertSublayer:colourView.layer atIndex:1];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)launchConnexion {
    UIViewController *vc = [[ConnexionViewController alloc] initWithNibName:@"ConnexionViewController" bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
}

- (void)launchHome {
    [Socket sharedCenter];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = BLUE_1;
    self.window.rootViewController = self.revealController;
    
    [self.window makeKeyAndVisible];

}

#pragma mark - PKRevealing

- (void)revealController:(PKRevealController *)revealController didChangeToState:(PKRevealControllerState)state
{
    //NSLog(@"%@ (%d)", NSStringFromSelector(_cmd), (int)state);
}

- (void)revealController:(PKRevealController *)revealController willChangeToState:(PKRevealControllerState)next
{
    //PKRevealControllerState current = revealController.state;
    //NSLog(@"%@ (%d -> %d)", NSStringFromSelector(_cmd), (int)current, (int)next);
}

#pragma mark - Helpers

- (UIViewController *)leftViewController
{
    UIViewController *leftViewController = [[UIViewController alloc] init];
    leftViewController.view.backgroundColor = BLUE_1;
    
    UITableView *tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height - 54 * 9) / 2.0f + 40, [[UIScreen mainScreen] bounds].size.width, /*54 * 8*/[[UIScreen mainScreen] bounds].size.height - 92) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = true;
        tableView;
    });
    
    [tableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [leftViewController.view addSubview:tableView];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 150, 42)];
    logoView.image = [UIImage imageNamed:@"logo_SZ.png"];
    [leftViewController.view addSubview:logoView];
    
    [self startPresentationMode];
    
    return leftViewController;
}

- (void)elementClicked:(id)elem {
    self.revealController.frontViewController = nil;
    UINavigationController *frontNavigationController;
    if ([elem isKindOfClass:[Music class]]){
        Music *music = (Music *)elem;
        AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
        vc.album = [[Album alloc] init];
        vc.album.identifier = music.albumId;
        vc.fromSearch = true;
        frontNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.revealController setFrontViewController:frontNavigationController];
    } else if ([elem isKindOfClass:[Album class]]) {
        Album *album = (Album *)elem;
        AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
        vc.album = album;
        vc.fromSearch = true;
        frontNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.revealController setFrontViewController:frontNavigationController];
    } else if ([elem isKindOfClass:[User class]]) {
        frontNavigationController = nil;
        User *artist = (User *)elem;
        if ([UsersController isArtist:artist.identifier]) {
            ArtistViewController *vc = [[ArtistViewController alloc] initWithNibName:@"ArtistViewController" bundle:nil];
            vc.artist = artist;
            vc.fromSearch = true;
            frontNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        } else {
            UserViewController *vc = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
            vc.user = artist;
            vc.fromSearch = true;
            frontNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        }
        [self.revealController setFrontViewController:frontNavigationController];
    } else if ([elem isKindOfClass:[Pack class]]) {
        Pack *pack = (Pack *)elem;
        PackDetailViewController *vc = [[PackDetailViewController alloc] initWithNibName:@"PackDetailViewController" bundle:nil];
        vc.pack = pack;
        vc.fromSearch = true;
        frontNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.revealController setFrontViewController:frontNavigationController];
    }
    [self.revealController resignPresentationModeEntirely:YES animated:YES completion:nil];
}

- (void)startPresentationMode
{
    if (![self.revealController isPresentationModeActive])
    {
        [self.revealController enterPresentationModeAnimated:YES completion:nil];
    }
    else
    {
        [self.revealController resignPresentationModeEntirely:NO animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *frontNavigationController;
    switch (indexPath.row) {
        case 0:
        {
            frontNavigationController = self.homeVC;
            [self.revealController setFrontViewController:frontNavigationController];
        }
            break;
        case 1:
            // explorer
        {
            frontNavigationController = self.exploreVC;
            [self.revealController setFrontViewController:frontNavigationController];
        }
            break;
        case 2:
            // pack
        {
            frontNavigationController = self.packVC;
            [self.revealController setFrontViewController:frontNavigationController];
        }
            break;
        case 3:
            // monde musical
        {
            frontNavigationController = self.geoVC;
            [self.revealController setFrontViewController:frontNavigationController];
        }
            break;
        case 4:
            // battles
        {
            frontNavigationController = self.battleVC;
            [self.revealController setFrontViewController:frontNavigationController];
        }
            break;
        case 5:
            // playlists
        {
            frontNavigationController = self.contentVC;
            [self.revealController setFrontViewController:frontNavigationController];
        }
            break;
        case 6:
            // amis
        {
            //frontNavigationController = self.friendsVC;
            [self.revealController setFrontViewController:[[UINavigationController alloc] initWithRootViewController:[[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil]]];
        }
            break;
        case 7:
            // cart
        {
            [self.revealController setFrontViewController:[[UINavigationController alloc] initWithRootViewController:[[CartViewController alloc] initWithNibName:@"CartViewController" bundle:nil]]];
            
        }
            break;
        case 8:
            // compte user
        {
            self.accountVC = [[UINavigationController alloc] initWithRootViewController:[[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:nil]];
            frontNavigationController = self.accountVC;
            [self.revealController setFrontViewController:frontNavigationController];
        }
            break;
        case 9:
            // feedback
        {
            frontNavigationController = self.feedbackVC;
            [self.revealController setFrontViewController:frontNavigationController];
        }
    }
    
    [self.revealController resignPresentationModeEntirely:true animated:true completion:nil];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *listOftitles = @[[self.translate.dict objectForKey:@"menu_news"],
                              [self.translate.dict objectForKey:@"menu_explore"],
                              [self.translate.dict objectForKey:@"menu_packs"],
                              [self.translate.dict objectForKey:@"menu_geoloc"],
                              [self.translate.dict objectForKey:@"menu_battle"],
                              [self.translate.dict objectForKey:@"menu_content"],
                              [self.translate.dict objectForKey:@"menu_network"],
                              [self.translate.dict objectForKey:@"menu_cart"],
                              [self.translate.dict objectForKey:@"menu_account"], @"Contact us"];
    
    cell.lbl.text = listOftitles[indexPath.row];
    return cell;
}


/****
 
 FACEBOOK DELEGATE METHODS
 
 ****/

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    if (!error && state == FBSessionStateOpen){
        
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *u, NSError *error) {
            if (!error) {
                
                NSString *token = [[[FBSession activeSession] accessTokenData] accessToken];
                User *user =  [IdenticationsController facebookConnect:token email:[u objectForKey:@"email"] uid:[u objectForKey:@"id"]];
                
                NSData *dataStore = [NSKeyedArchiver archivedDataWithRootObject:user];
                [[NSUserDefaults standardUserDefaults] setObject:dataStore forKey:@"User"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self launchHome];
            }
        }];
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        
    }
    
    if (error){
       
        NSString *alertText;
        NSString *alertTitle;
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
        } else {
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
            
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
            } else {
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
            }
        }
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActive];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //NSLog(@"source application = %@", sourceApplication);
    //NSLog(@"type : %i", self.type);
    
    if (self.type == 1)
    {
        [FBSession.activeSession setStateChangeHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    }
    
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    //return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (void)setTypeConnexion:(int)type
{
    self.type = type;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPause:
               [[AudioPlayer sharedCenter] pauseSound];
                break;
            case UIEventSubtypeRemoteControlPlay:
                [[AudioPlayer sharedCenter] playSound];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [[AudioPlayer sharedCenter] previous];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [[AudioPlayer sharedCenter] next];
                break;
            default:
                break;
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application beginReceivingRemoteControlEvents];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
