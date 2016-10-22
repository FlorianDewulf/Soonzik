//
//  HeaderPackDetailView.m
//  SoonZik
//
//  Created by Maxime Sauvage on 06/07/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "HeaderPackDetailView.h"

@implementation HeaderPackDetailView

- (void)initHeader:(Pack *)pack {
    UIImageView *album1Image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height/2)];
    [self addSubview:album1Image];
    UIImageView *album2Image = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height/2)];
    [self addSubview:album2Image];
    UIImageView *album3Image = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height/2)];
    [self addSubview:album3Image];
    UIImageView *album4Image = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height/2)];
    [self addSubview:album4Image];
        
    int i = 1;
    for (Album *album in pack.listOfAlbums) {
        NSString *urlImage = [NSString stringWithFormat:@"%@assets/albums/%@", API_URL, album.image];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
        switch (i) {
            case 1:
                album1Image.image = [UIImage imageWithData:imageData];
                i++;
                break;
            case 2:
                album2Image.image = [UIImage imageWithData:imageData];
                i++;
                break;
            case 3:
                album3Image.image = [UIImage imageWithData:imageData];
                i++;
                break;
            case 4:
                album4Image.image = [UIImage imageWithData:imageData];
                i++;
                break;
            default:
                break;
        }
    }
    //return view;
}

@end
