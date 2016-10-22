//
//  SubscribeViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 03/09/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "SubscribeViewController.h"
#import "SimplePopUp.h"
#import "IdenticationsController.h"
#import "AppDelegate.h"

@interface SubscribeViewController ()

@end

@implementation SubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:false];
    self.view.backgroundColor = DARK_GREY;
    self.contentView.backgroundColor = DARK_GREY;
    self.scrollView.backgroundColor = DARK_GREY;
    
    self.listOfLanguages = [IdenticationsController getLanguages];
    
    [self.contentView layoutIfNeeded];
    CGSize size = CGSizeMake(self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    self.scrollView.contentSize = size;
    [self.scrollView addSubview:self.contentView];
    
    self.emailTxtField.placeholder = @"Adresse mail";
    self.passwordTxtField.placeholder = @"Mot de passe";
    self.confPasswordTxtField.placeholder = @"Confirmer le mot de passe";
    self.usernameTxtField.placeholder = @"Username";
    self.firstnameTxtField.placeholder = @"Prénom";
    self.lastnameTxtField.placeholder = @"Nom";
    self.birthdayTxtField.placeholder = @"Date de naissance";
    self.languageTxtField.placeholder = @"Langue";
    
    self.titleLabel.text = @"Inscrivez-vous";
    
    self.languageTxtField.delegate = self;
    self.birthdayTxtField.delegate = self;
    
    [self.subscribeButton addTarget:self action:@selector(subscribe) forControlEvents:UIControlEventTouchUpInside];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-250, self.view.frame.size.width, 250)];
    self.datePicker.backgroundColor = DARK_GREY;
    [self.datePicker setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    [self.datePicker addTarget:self action:@selector(datePickerChanged) forControlEvents:UIControlEventValueChanged];
    self.datePicker.maximumDate = [NSDate date];
    [self.contentView addSubview:self.datePicker];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.hidden = true;
    
    self.languagePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-250, self.view.frame.size.width, 250)];
    self.languagePicker.backgroundColor = DARK_GREY;
    self.languagePicker.delegate = self;
    self.languagePicker.dataSource = self;
    self.languagePicker.hidden = true;
    [self.contentView addSubview:self.languagePicker];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *reco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayDatePicker)];
    [self.datePicker addGestureRecognizer:reco];
    
    UITapGestureRecognizer *reco2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayLanguagePicker)];
    [self.languagePicker addGestureRecognizer:reco2];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.listOfLanguages.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    Language *language = [self.listOfLanguages objectAtIndex:row];
    self.languageTxtField.text = language.abbreviation;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
             attributedTitleForRow:(NSInteger)row
                      forComponent:(NSInteger)component
{
    Language *language = [self.listOfLanguages objectAtIndex:row];
    return [[NSAttributedString alloc] initWithString:language.language
                                           attributes:@
            {
            NSForegroundColorAttributeName:[UIColor whiteColor]
            }];
}

-(void)dismissKeyboard {
    for (UIView *textfield in self.view.subviews) {
        [textfield endEditing:true];
    }
    
    if (!self.datePicker.isHidden)
        [self displayDatePicker];
    
    if (!self.languagePicker.isHidden)
        [self displayLanguagePicker];
}

- (void)datePickerChanged {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.birthdayTxtField.text = [formatter stringFromDate:self.datePicker.date];
}

- (void)subscribe {
    NSLog(@"subscribe");
    if (self.emailTxtField.text == nil ||
        self.passwordTxtField.text == nil ||
        self.confPasswordTxtField.text == nil ||
        self.usernameTxtField.text == nil ||
        self.firstnameTxtField.text == nil ||
        self.lastnameTxtField.text == nil ||
        self.birthdayTxtField.text == nil ||
        self.languageTxtField.text == nil) {
        
        NSLog(@"pas tous les champs remplis");
        [[[SimplePopUp alloc] initWithMessage:@"Veuillez remplir tous les champs" onView:self.contentView withSuccess:false] show];
        
    } else if (![self.passwordTxtField.text isEqualToString:self.confPasswordTxtField.text]) {
        [[[SimplePopUp alloc] initWithMessage:@"Les mots de passes ne correspondent pas" onView:self.contentView withSuccess:false] show];
        
    } else {
        NSLog(@"inscription");
        User *user = [[User alloc] init];
        user.email = self.emailTxtField.text;
        user.password = self.passwordTxtField.text;
        user.username = self.usernameTxtField.text;
        user.firstname = self.firstnameTxtField.text;
        user.lastname = self.lastnameTxtField.text;
        user.birthday = self.birthdayTxtField.text;
        user.language = self.languageTxtField.text;
        
        user = [IdenticationsController subscribe:user];
        if (user != nil) {
            NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
            NSData *dataStore = [NSKeyedArchiver archivedDataWithRootObject:user];
            [preferences setObject:dataStore forKey:@"User"];
            [preferences synchronize];
            
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app launchHome];
        }
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.birthdayTxtField) {
        [self displayDatePicker];
        return false;
    }
    if (textField == self.languageTxtField) {
        [self displayLanguagePicker];
        return false;
    }

    return true;
}

- (void)displayDatePicker {
    if (self.datePicker.isHidden) {
        self.datePicker.hidden = false;
    } else {
        self.datePicker.hidden = true;
    }
}

- (void)displayLanguagePicker {
    if (self.languagePicker.isHidden) {
        self.languagePicker.hidden = false;
    } else {
        self.languagePicker.hidden = true;
    }
}

@end
