//
//  NewsNouvelleCell.h
//  SoonZik
//
//  Created by Maxime Sauvage on 18/02/15.
//  Copyright (c) 2015 Coordina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareDelegate.h"
#import "News.h"

@interface NewsNouvelleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *newsImage;

@property (strong, nonatomic) News *news;

@property (nonatomic, strong) id<ShareDelegate>shareDelegate;

- (void)initCellWithNews:(News *)news;

@end
