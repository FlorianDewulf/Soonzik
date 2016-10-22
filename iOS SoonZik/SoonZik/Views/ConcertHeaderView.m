//
//  ConcertHeaderView.m
//  SoonZik
//
//  Created by Maxime Sauvage on 05/11/15.
//  Copyright © 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "ConcertHeaderView.h"
#import "Tools.h"
#import "SVGKImage.h"

@implementation ConcertHeaderView

- (void)initHeader:(Concert *)concert {
    self.imgV.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.imgV.layer.shadowOffset = CGSizeMake(5, 5);
    self.imgV.layer.shadowRadius = 5.0;
    self.imgV.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imgV.layer.shadowOpacity = 0.8;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.artistLabel.text = concert.artist.username;
    self.artistLabel.font = SOONZIK_FONT_BODY_MEDIUM;
    self.artistLabel.textColor = [UIColor whiteColor];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, concert.artist.image];
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imgV.image = [UIImage imageWithData:imageData];
        });
    });
    
    [self.shareButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"share_white"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [self.artistButton setImage:[Tools imageWithImage:[SVGKImage imageNamed:@"user"].UIImage scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    [self.shareButton setTintColor:[UIColor whiteColor]];
    [self.artistButton setTintColor:[UIColor whiteColor]];
}

@end
