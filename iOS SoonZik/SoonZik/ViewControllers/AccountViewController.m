//
//  AccountViewController.m
//  SoonZik
//
//  Created by Maxime Sauvage on 23/04/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "AccountViewController.h"
#import "User.h"
#import "SimplePopUp.h"
#import "UsersController.h"

@interface AccountViewController ()
@end

@implementation AccountViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    self.translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    [self.contentView layoutIfNeeded];
    CGSize size = CGSizeMake(self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    self.scrollView.contentSize = size;
    [self.scrollView addSubview:self.contentView];
    
    self.view.backgroundColor = DARK_GREY;
    self.contentView.backgroundColor = DARK_GREY;

    
    self.view.backgroundColor = DARK_GREY;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:[self.translate.dict objectForKey:@"save"] style:UIBarButtonItemStyleDone target:self action:@selector(saveUserData)];
    doneButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.preferences = [NSUserDefaults standardUserDefaults];
    NSData *data = [self.preferences objectForKey:@"User"];
    self.user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self fillData];
}

- (void)fillData {
    self.usernameTitle.text = [self.translate.dict objectForKey:@"title_username"];
    self.firstnameTitle.text = [self.translate.dict objectForKey:@"title_firstname"];
    self.lastnameTitle.text = [self.translate.dict objectForKey:@"title_lastname"];
    self.emailTitle.text = [self.translate.dict objectForKey:@"title_email"];
    self.numberTitle.text = [self.translate.dict objectForKey:@"title_number"];
    self.streetTitle.text = [self.translate.dict objectForKey:@"title_street"];
    self.zipTitle.text = [self.translate.dict objectForKey:@"title_zip"];
    self.cityTitle.text = [self.translate.dict objectForKey:@"title_city"];
    self.countryTitle.text = [self.translate.dict objectForKey:@"title_country"];
    
    UIActivityIndicatorView *spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    dispatch_async(backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, self.user.image];
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            [self.userImageButton setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
            [spin stopAnimating];
        });
        spin.center = self.userImageButton.center;
        [self.view addSubview:spin];
        [spin startAnimating];

    });
    
    [self.userImageButton addTarget:self action:@selector(uploadPicture) forControlEvents:UIControlEventTouchUpInside];
    self.usernameTextField.text = self.user.username;
    self.fnameTextField.text = self.user.firstname;
    self.lnameTextField.text = self.user.lastname;
    self.emailTextField.text = self.user.email;
    self.numberTextField.text = self.user.address.streetNbr;
    self.streetTextField.text = self.user.address.street;
    self.zipTextField.text = self.user.address.zipCode;
    self.cityTextField.text = self.user.address.city;
    self.countryTextField.text = self.user.address.country;
}

- (void)saveUserData {
    self.user.username = self.usernameTextField.text;
    self.user.firstname = self.fnameTextField.text;
    self.user.lastname = self.lnameTextField.text;
    self.user.email = self.emailTextField.text;
    self.user.address = [[Address alloc] init];
    self.user.address.streetNbr = self.numberTextField.text;
    self.user.address.street = self.streetTextField.text;
    self.user.address.zipCode = self.zipTextField.text;
    self.user.address.city = self.cityTextField.text;
    self.user.address.country = self.countryTextField.text;
    
    if ([UsersController update:self.user] == nil) {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"update_error"] onView:self.view withSuccess:false] show];
    } else {
        [[[SimplePopUp alloc] initWithMessage:[self.translate.dict objectForKey:@"account_update"] onView:self.view withSuccess:true] show];
        self.preferences = [NSUserDefaults standardUserDefaults];
        NSData *dataStore = [NSKeyedArchiver archivedDataWithRootObject:self.user];
        [self.preferences setObject:dataStore forKey:@"User"];
        [self.preferences synchronize];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
}

- (void)uploadPicture {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:true completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:true completion:nil];
    
    __block __weak NSData *imageData = nil;
    __block __weak NSString *imageFormat, *imageOriginalName = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
       ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
       {
            ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
            NSArray *substrings = [[imageRep filename] componentsSeparatedByString:@"."];
            NSString *format = [substrings objectAtIndex:1];
            imageOriginalName = [substrings objectAtIndex:0];
            UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
            if ([format isEqualToString:@"JPG"]) {
                imageFormat = @"image/jpeg";
                imageData = UIImageJPEGRepresentation(image, 1);
            } else if ([format isEqualToString:@"PNG"]) {
                imageFormat = @"image/png";
                imageData = UIImagePNGRepresentation(image);
            }
           [self uploadImage:imageFormat :imageOriginalName :imageData];
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:^(NSError *error){
        }];
    });

}

- (void)uploadImage:(NSString *)imageFormat :(NSString *)imageName :(NSData *)imageData {
    NSString *url, *post, *key, *conca, *secureKey;
    NSDictionary *json;
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    User *user = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    url = [NSString stringWithFormat:@"%@users/upload", API_URL];
    key = [Crypto getKey];
    conca = [NSString stringWithFormat:@"%@%@", user.salt, key];
    secureKey = [Crypto sha256HashFor:conca];
    post = [NSString stringWithFormat:@"user_id=%i&secureKey=%@&type=image&file[content_type]=%@&file[original_filename]=%@&file[tempfile]=%@&device=smartphone", user.identifier, secureKey, imageFormat, imageName, imageData];
    
    json = [Request postRequest:post url:url];
    
    if ([[json objectForKey:@"code"] intValue] == 201) {
        [[[SimplePopUp alloc] initWithMessage:@"pas d'erreur" onView:self.view withSuccess:true] show];
    } else {
        [[[SimplePopUp alloc] initWithMessage:@"erreur" onView:self.view withSuccess:false] show];
    }

}

- (IBAction)shouldReturnTextField:(id)sender {
    
}

@end
