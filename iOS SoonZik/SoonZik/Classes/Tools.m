//
//  Tools.m
//  RoomForDay
//
//  Created by Maxime Sauvage on 20/11/2014.
//  Copyright (c) 2014 ok. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
