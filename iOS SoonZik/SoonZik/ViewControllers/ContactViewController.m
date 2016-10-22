//
//  ContactViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 27/10/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ContactViewController.h"
#import "FeedbackController.h"
#import "SimplePopUp.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5.0f;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = [UIColor whiteColor];
    self.textView.delegate = self;
    self.textView.font = SOONZIK_FONT_BODY_SMALL;
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
    self.descLabel.text = @"Something you want to notice us?";
    self.descLabel.textColor = [UIColor whiteColor];
    self.descLabel.font = SOONZIK_FONT_BODY_MEDIUM;
    
    [self.pickerView setHidden:true];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.tintColor = [UIColor whiteColor];
    
    self.objectTextField.layer.masksToBounds = YES;
    self.objectTextField.layer.cornerRadius = 5.0f;
    self.objectTextField.layer.borderWidth = 1;
    self.objectTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.objectTextField.backgroundColor = [UIColor clearColor];
    self.objectTextField.textColor = [UIColor whiteColor];
    self.objectTextField.delegate = self;
    self.objectTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Object of the feedback" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [self.button setTintColor:[UIColor whiteColor]];
    self.button.titleLabel.font = SOONZIK_FONT_BODY_MEDIUM;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePickerView)];
    [self.view addGestureRecognizer:tap];
    
    [self.button addTarget:self action:@selector(openPickerView) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:@"Reason you want to contact us ?" forState:UIControlStateNormal];
    
    [self.sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sendMessage {
    [self closePickerView];
    if ([FeedbackController sendFeedback:self.button.titleLabel.text object:self.objectTextField.text text:self.textView.text]) {
        [[[SimplePopUp alloc] initWithMessage:@"Your feedback has been sent" onView:self.view withSuccess:true] show];
        self.textView.text = @"";
    } else {
        [[[SimplePopUp alloc] initWithMessage:@"Your feedback has not been sent" onView:self.view withSuccess:false] show];
    }
}

- (void)closePickerView {
    [self.pickerView setHidden:true];
}

- (void)openPickerView {
    [self.pickerView setHidden:false];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self closePickerView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return false;
    }
    return true;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 4;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
             attributedTitleForRow:(NSInteger)row
                      forComponent:(NSInteger)component
{
    NSString *title;
    if (row == 0) {
        title = @"bug";
    } else if (row == 1) {
        title = @"account";
    } else if (row == 2) {
        title = @"payment";
    } else {
        title = @"other";
    }
    
    return [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *title;
    if (row == 0) {
        title = @"bug";
    } else if (row == 1) {
        title = @"account";
    } else if (row == 2) {
        title = @"payment";
    } else {
        title = @"other";
    }
    [self.button setTitle:title forState:UIControlStateNormal];
}

@end
