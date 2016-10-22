//
//  BattleTableViewCell.m
//  SoonZik
//
//  Created by Maxime Sauvage on 30/06/15.
//  Copyright (c) 2015 SoonZik - Maxime SAUVAGE. All rights reserved.
//

#import "BattleTableViewCell.h"
#import "Translate.h"

@implementation BattleTableViewCell

- (void)initCell:(User *)artist1 :(User *)artist2 {
    
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    dispatch_async(backgroundQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, artist1.image];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            self.imgv1.image = [UIImage imageWithData:imageData];
        });
    });
    
    dispatch_queue_t backgroundQueue2 = dispatch_queue_create("com.mycompany.myqueue", 0);
    dispatch_async(backgroundQueue2, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/usersImage/avatars/%@", API_URL, artist2.image];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            self.imgv2.image = [UIImage imageWithData:imageData];
        });
    });
    
    self.label1.text = artist1.username;
    self.label2.text = artist2.username;
    
    NSData *translateData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Translate"];
    Translate *translate = [NSKeyedUnarchiver unarchiveObjectWithData:translateData];
    
    self.labelVS.text = [translate.dict objectForKey:@"battle_versus"];
    
    self.imgv1.layer.cornerRadius = 40;
    self.imgv2.layer.cornerRadius = 40;
    self.imgv1.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imgv2.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imgv1.layer.borderWidth = 1;
    self.imgv2.layer.borderWidth = 1;
    self.imgv1.layer.masksToBounds = true;
    self.imgv2.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
