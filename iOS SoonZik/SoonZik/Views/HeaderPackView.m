//
//  HeaderPackView.m
//  SoonZik
//
//  Created by Maxime Sauvage on 30/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "HeaderPackView.h"
#import "Pack.h"

@implementation HeaderPackView

- (void)createSliderWithPacks:(NSArray *)listOfPacks andPage:(int)index
{
    self.indexOfPage = index;
    self.listOfPacks = listOfPacks;
    
    Pack *currentPack = [self.listOfPacks objectAtIndex:self.indexOfPage];
    
    self.packTitleLabel.font = SOONZIK_FONT_BODY_BIG;
    self.packTitleLabel.text = currentPack.title;
    self.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    float imageWith = 304;
    float imageEcart = (self.scrollView.frame.size.width - imageWith) / 2;
    self.scrollView.clipsToBounds = NO;
    
    CGFloat contentOffset = 0.0f;
    
    for (int i = 0; i < listOfPacks.count; i++) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(i * imageWith + imageEcart * (i * 2 + 1), self.scrollView.frame.origin.y, imageWith, imageWith)];
        Pack *pack = [listOfPacks objectAtIndex:i];
        NSArray *listOfAlbums = pack.listOfAlbums;
        imgV.layer.backgroundColor = [UIColor blackColor].CGColor;
        imgV.layer.shadowOffset = CGSizeMake(5, 5);
        imgV.layer.shadowRadius = 5.0;
        imgV.layer.shadowColor = [UIColor blackColor].CGColor;
        imgV.layer.shadowOpacity = 0.8;
        
        [imgV addSubview:[self loadImagePreviewPack:listOfAlbums andImageView:imgV]];
        [self.scrollView addSubview:imgV];
        contentOffset += self.scrollView.frame.size.width;
        
    }
    self.scrollView.contentSize = CGSizeMake(contentOffset, self.scrollView.frame.size.height);
    self.scrollView.contentOffset = CGPointMake((contentOffset / listOfPacks.count) * self.indexOfPage, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    Pack *pack = [self.listOfPacks objectAtIndex:self.indexOfPage];
    self.packTitleLabel.text = pack.title;
    
    [self.slideDelegate changeIndex:self.indexOfPage];
}

- (UIView *)loadImagePreviewPack:(NSArray *)albums andImageView:(UIImageView *)imageView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    UIImageView *album1Image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageView.frame.size.width/2, imageView.frame.size.height/2)];
    [view addSubview:album1Image];
    UIImageView *album2Image = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.size.width/2, 0, imageView.frame.size.width/2, imageView.frame.size.height/2)];
    [view addSubview:album2Image];
    UIImageView *album3Image = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height/2, imageView.frame.size.width/2, imageView.frame.size.height/2)];
    [view addSubview:album3Image];
    UIImageView *album4Image = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.size.width/2, imageView.frame.size.height/2, imageView.frame.size.width/2, imageView.frame.size.height/2)];
    [view addSubview:album4Image];
    
    int i = 1;
    for (Album *album in albums) {
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
    return view;
}


@end
