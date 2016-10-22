//
//  AccountViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 23/04/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TypeViewController.h"
#import "User.h"

@interface AccountViewController : TypeViewController <UITextFieldDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSUserDefaults *preferences;
@property (nonatomic, strong) User *user;

@property (strong, nonatomic) IBOutlet UIButton *userImageButton;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *fnameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lnameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *numberTextField;
@property (strong, nonatomic) IBOutlet UITextField *streetTextField;
@property (strong, nonatomic) IBOutlet UITextField *zipTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) IBOutlet UITextField *countryTextField;

@property (strong, nonatomic) IBOutlet UILabel *usernameTitle;
@property (strong, nonatomic) IBOutlet UILabel *firstnameTitle;
@property (strong, nonatomic) IBOutlet UILabel *lastnameTitle;
@property (strong, nonatomic) IBOutlet UILabel *emailTitle;
@property (strong, nonatomic) IBOutlet UILabel *numberTitle;
@property (strong, nonatomic) IBOutlet UILabel *streetTitle;
@property (strong, nonatomic) IBOutlet UILabel *zipTitle;
@property (strong, nonatomic) IBOutlet UILabel *cityTitle;
@property (strong, nonatomic) IBOutlet UILabel *countryTitle;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

- (IBAction)shouldReturnTextField:(id)sender;

@end
