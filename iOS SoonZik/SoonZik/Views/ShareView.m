//
//  ShareView.m
//  SoonZik
//
//  Created by Maxime Sauvage on 23/05/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ShareView.h"
#import "News.h"
#import "Tools.h"
#import "SVGKImage.h"
#import "SimplePopUp.h"
#import "Album.h"
#import "SocialConnect.h"

@implementation ShareView

- (id)initWithElement:(id)elem onView:(UIView *)view {
    self = [super init];
    
    self.facebookbSharing = false;
    self.twitterSharing = false;
    
    self.frame = CGRectMake(view.frame.size.width*0.05, 0, view.frame.size.width*0.9, 300);
    self.center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
    
    self.backgroundColor = DARK_GREY;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1;
    
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(-10, 15);
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.5;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width*0.3-5, self.frame.size.width*0.3-5)];
    [self addSubview:imageV];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageV.frame.size.width + 5+5, 5, self.frame.size.width - imageV.frame.size.width - 10 - 5, imageV.frame.size.width)];
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:titleLabel];

    
    if ([elem isKindOfClass:[News class]]) {
        News *obj = (News *)elem;
        titleLabel.text = obj.title;
        //NSLog(@"share news");
        imageV.image = [UIImage imageNamed:@"news_icon"];
    } else if ([elem isKindOfClass:[User class]]) {
        //NSLog(@"share artist");
        User *artist = (User *)elem;
        titleLabel.text = artist.username;
        imageV.image = [UIImage imageNamed:artist.image];
    } else if ([elem isKindOfClass:[Album class]]) {
        //NSLog(@"share album");
        Album *album = (Album *)elem;
        titleLabel.text = [NSString stringWithFormat:@"%@ par %@", album.title, album.artist.username];
        imageV.image = [UIImage imageNamed:album.image];
    }
    
    self.twitterButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-34, self.frame.size.height-34, 30, 30)];
    [self.twitterButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"twitter_disable"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [self.twitterButton addTarget:self action:@selector(shareWithTwitter) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.twitterButton];
    
    self.facebookButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-34-34, self.frame.size.height-34, 30, 30)];
    [self.facebookButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"facebook_disable"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [self.facebookButton addTarget:self action:@selector(shareWithFacebook) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.facebookButton];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(4, imageV.frame.size.height+8, self.frame.size.width-8, self.frame.size.height-imageV.frame.size.height-8-40)];
    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor whiteColor];
    textView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 2;
    textView.tintColor = [UIColor whiteColor];
    textView.returnKeyType = UIReturnKeySend;
    [self addSubview:textView];
    
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ((point.x < self.frame.origin.x) || (point.x > (self.frame.origin.x + self.frame.size.width))) {
        [self.closeDelegate closeView];
    } else if ((point.y < self.frame.origin.y) || (point.y > (self.frame.origin.y + self.frame.size.height))) {
        [self.closeDelegate closeView];
    }
    
    return true;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self share];
        return false;
    }
    return true;
}

- (void)shareWithFacebook {
    if (self.facebookbSharing) {
        self.facebookbSharing = false;
        [self.facebookButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"facebook_disable"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    } else {
        self.facebookbSharing = true;
        [self.facebookButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"facebook"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    }
}

- (void)shareWithTwitter {
    if (self.twitterSharing) {
        self.twitterSharing = false;
        [self.twitterButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"twitter_disable"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    } else {
        self.twitterSharing = true;
        [self.twitterButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"twitter"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    }
}


- (void)share {
    //[SocialConnect shareOnFacebookWithTitle:@"test" andImage:[UIImage imageNamed:@""] andDescription:@"description longue"];
    
    if (self.twitterSharing == false && self.facebookbSharing == false) {
        [[[SimplePopUp alloc] initWithMessage:@"Choisissez un réseau social" onView:self.superview] show];
    } else {
        [self.closeDelegate closeView];
    }
}

@end
