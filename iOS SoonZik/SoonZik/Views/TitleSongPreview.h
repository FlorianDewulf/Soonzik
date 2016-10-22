//
//  TitleSongPreview.h
//  SoonZik
//
//  Created by Maxime Sauvage on 14/01/2015.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleSongPreview : UIView

@property (nonatomic, strong) IBOutlet UIImageView *albumImage;
@property (nonatomic, strong) IBOutlet UILabel *trackLabel;
@property (nonatomic, strong) IBOutlet UILabel *artistLabel;

@end
