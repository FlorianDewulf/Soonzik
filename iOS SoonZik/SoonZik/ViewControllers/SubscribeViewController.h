//
//  SubscribeViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 03/09/2015.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscribeViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *emailTxtField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTxtField;
@property (nonatomic, strong) IBOutlet UITextField *confPasswordTxtField;
@property (nonatomic, strong) IBOutlet UITextField *usernameTxtField;
@property (nonatomic, strong) IBOutlet UITextField *birthdayTxtField;
@property (nonatomic, strong) IBOutlet UITextField *languageTxtField;
@property (nonatomic, strong) IBOutlet UITextField *firstnameTxtField;
@property (nonatomic, strong) IBOutlet UITextField *lastnameTxtField;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UIButton *subscribeButton;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *contentView;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIPickerView *languagePicker;

@property (nonatomic, strong) NSMutableArray *listOfLanguages;

@end
