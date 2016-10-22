//
//  CollectionReusableView.h
//  SoonZik
//
//  Created by Maxime Sauvage on 20/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) IBOutlet UILabel *titleL;
@property (nonatomic, strong) IBOutlet UILabel *numberLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageV;

@end
