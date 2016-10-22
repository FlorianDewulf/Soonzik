//
//  ConnexionViewController.h
//  SoonZik
//
//  Created by devmac on 21/05/14.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"
#import <GooglePlus/GPPSignIn.h>
#import "Translate.h"

@interface ConnexionViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, GPPSignInDelegate>

@property (assign, nonatomic) bool isFacebookAvailable;
@property (strong, nonatomic) NSString *fbID, *globalFBID;
@property (nonatomic, strong) NSUserDefaults *prefs;
@property (strong, nonatomic) UIActivityIndicatorView *loadingDataIndicator;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) int indexOfScroll;
@property (strong, nonatomic) IBOutlet UIView *kindOfConnexionArea;
@property (strong, nonatomic) IBOutlet UIView *emailConnexionArea;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *googleButton;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *connexionButton;
@property (strong, nonatomic) IBOutlet UIButton *subscribeButton;
@property (strong, nonatomic) IBOutlet UIImageView *soonzikLogo;
@property (strong, nonatomic) Translate *translate;
@property (nonatomic, strong) GPPSignIn *signIn;

@end
