//
//  ConnexionViewController.m
//  SoonZik
//
//  Created by devmac on 21/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "ConnexionViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "Tools.h"
#import "SVGKImage.h"
#import "SocialConnect.h"
#import "SearchViewController.h"
#import "SimplePopUp.h"
#import "SubscribeViewController.h"
#import "IdenticationsController.h"

#import <FacebookSDK/FacebookSDK.h>
#import <TwitterKit/TwitterKit.h>

#import <GoogleOpenSource/GoogleOpenSource.h>

@interface ConnexionViewController ()

@end

@implementation ConnexionViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self initializeButtons];
    
    [self.kindOfConnexionArea setFrame:CGRectMake(self.kindOfConnexionArea.frame.origin.x, self.view.frame.size.height / 2, self.kindOfConnexionArea.frame.size.width, self.kindOfConnexionArea.frame.size.height)];
    
    self.loadingDataIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.loadingDataIndicator.center = CGPointMake(160, self.view.frame.size.height-100);
    self.loadingDataIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.loadingDataIndicator];
    
    self.view.backgroundColor = DARK_GREY;
    [self.emailAddressTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.emailAddressTextField.delegate = self;
    self.emailAddressTextField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    [self.passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.passwordTextField.delegate = self;
    self.passwordTextField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    
    [self.connexionButton addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    [self.subscribeButton addTarget:self action:@selector(subscribe) forControlEvents:UIControlEventTouchUpInside];
    
    [self createSlider];
}

- (void)subscribe {
    SubscribeViewController *vc = [[SubscribeViewController alloc] initWithNibName:@"SubscribeViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)connect {
    User *user = [IdenticationsController emailConnect:self.emailAddressTextField.text andPassword:self.passwordTextField.text];

    if (user == nil) {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"connect_failed"] onView:self.view withSuccess:false] show];
    } else {
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        NSData *dataStore = [NSKeyedArchiver archivedDataWithRootObject:user];
        [preferences setObject:dataStore forKey:@"User"];
        [preferences synchronize];
   
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app launchHome];
    }
}

- (void)initializeButtons
{
    [self.facebookButton addTarget:self action:@selector(loginWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self.facebookButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"facebook"].UIImage scaledToSize:CGSizeMake(66, 66)] forState:UIControlStateNormal];
    [self.googleButton addTarget:self action:@selector(loginWithGoogle) forControlEvents:UIControlEventTouchUpInside];
    [self.googleButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"googleplus"].UIImage scaledToSize:CGSizeMake(66, 44)] forState:UIControlStateNormal];
    [self.twitterButton addTarget:self action:@selector(loginWithTwitter) forControlEvents:UIControlEventTouchUpInside];
    [self.twitterButton setBackgroundImage:[Tools imageWithImage:[SVGKImage imageNamed:@"twitter"].UIImage scaledToSize:CGSizeMake(66, 66)] forState:UIControlStateNormal];
}

- (void)createSlider
{
    self.indexOfScroll = 0;
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.clipsToBounds = NO;
    
    CGFloat contentOffset = 0.0f;
    
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        label.text = [self.translate.dict objectForKey:@"soonzik_phrase_1"];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        label.numberOfLines = 3;
        [self.scrollView addSubview:label];
        contentOffset += self.scrollView.frame.size.width;
    }
    
    self.scrollView.contentSize = CGSizeMake(contentOffset, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake((contentOffset / 3) * self.indexOfScroll, 0);
    self.scrollView.delegate = self;
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(changeScroll) userInfo:nil repeats:YES];
}

- (void) changeScroll
{
    if (self.indexOfScroll == 2) {
        self.indexOfScroll = 0;
    } else {
        self.indexOfScroll++;
    }
    
    [self.scrollView setContentOffset:CGPointMake((self.scrollView.frame.size.width * 3 / 3) * self.indexOfScroll, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.indexOfScroll = scrollView.contentOffset.x / scrollView.frame.size.width;
}


- (void)loginWithFacebook
{
    AppDelegate *delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate setTypeConnexion:1];
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
    } else {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
        
    }
}

- (void)loginWithTwitter
{
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session != nil) {
            NSLog(@"session.userName : %@", session.userName);
            NSLog(@"session.userID : %@", session.userID);
            NSLog(@"session.authToken : %@", session.authToken);
            NSLog(@"session.authTokenSecret : %@", session.authTokenSecret);
            NSLog(@"%@", session);
        
            User *user =  [IdenticationsController twitterConnect:session.authToken uid:session.userID];
            
            if (user.identifier != 0) {
                NSLog(@"user saved");
                NSData *dataStore = [NSKeyedArchiver archivedDataWithRootObject:user];
                [[NSUserDefaults standardUserDefaults] setObject:dataStore forKey:@"User"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                [appDelegate launchHome];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occured. Please ensure that your Twitter account is liked with your SoonZik account" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
            }
        }
    }];
}

- (void)loginWithGoogle
{
    NSLog(@"Login with google");
    self.signIn = [GPPSignIn sharedInstance];
    self.signIn.clientID = googleClientID;
    self.signIn.scopes = [NSArray arrayWithObjects: kGTLAuthScopePlusLogin, kGTLAuthScopePlusMe, kGTLAuthScopePlusUserinfoProfile, nil];
    self.signIn.delegate = self;
    self.signIn.shouldFetchGooglePlusUser = true;
    self.signIn.shouldFetchGoogleUserID = true;
    self.signIn.shouldFetchGoogleUserEmail = true;
    [self.signIn authenticate];
}

/**
    GOOGLE CONNECT
 **/

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth error: (NSError *) error
{
    [FBSession.activeSession closeAndClearTokenInformation];
    
    AppDelegate *delegate =(AppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate setTypeConnexion:2];
    
    User *user =  [IdenticationsController googleConnect:self.signIn.authentication.accessToken uid:self.signIn.userID];
    
    if (user.identifier != 0) {
        NSData *dataStore = [NSKeyedArchiver archivedDataWithRootObject:user];
        [[NSUserDefaults standardUserDefaults] setObject:dataStore forKey:@"User"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [delegate launchHome];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"An error has occured. Please ensure that your Google+ account is liked with your SoonZik account" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
    }
}

-(void)refreshInterfaceBasedOnSignIn
{
    if ([[GPPSignIn sharedInstance] authentication]) {
        // L'utilisateur est connecté.
        self.googleButton.hidden = YES;
        // Effectuer d'autres actions ici, comme afficher un bouton de déconnexion, par exemple
    } else {
        self.googleButton.hidden = NO;
        // Effectuer d'autres actions ici
    }
}

- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}

- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        [[[SimplePopUp alloc] initWithMessage:error.description onView:self.view withSuccess:false] show];
    } else {
        // L'utilisateur est déconnecté et l'application dissociée de Google+.
        // Effacer les données de l'utilisateur conformément aux conditions d'utilisation de la Plate-forme Google+.
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
   [self.view endEditing:YES];
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

@end
