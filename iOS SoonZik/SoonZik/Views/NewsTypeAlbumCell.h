//
//  NewsTypeAlbumCell.h
//  SoonZik
//
//  Created by LLC on 08/07/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "ShareDelegate.h"

@interface NewsTypeAlbumCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) News *news;

@property (nonatomic, strong) id<ShareDelegate>shareDelegate;

- (void)initCellWithNews:(News *)news;

@end
