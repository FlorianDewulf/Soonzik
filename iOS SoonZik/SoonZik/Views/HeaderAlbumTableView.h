//
//  HeaderAlbumTableView.h
//  SoonZik
//
//  Created by Maxime Sauvage on 09/10/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderAlbumTableView : UIView

@property (nonatomic, strong) IBOutlet UIImageView *albumImage;
@property (nonatomic, strong) IBOutlet UILabel *albumTitle;
@property (nonatomic, strong) IBOutlet UILabel *releaseDateLabel;
@property (nonatomic, strong) IBOutlet UILabel *artistLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberLikesLabel;

@property (nonatomic, strong) IBOutlet UIButton *buyButton;

- (void)initHeader;

@end
