//
//  ContactViewController.h
//  SoonZik
//
//  Created by Maxime Sauvage on 27/10/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "TypeViewController.h"

@interface ContactViewController : TypeViewController <UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *descLabel;
@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UIButton *sendButton;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) IBOutlet UIButton *button;
@property (nonatomic, strong) IBOutlet UITextField *objectTextField;

@end
