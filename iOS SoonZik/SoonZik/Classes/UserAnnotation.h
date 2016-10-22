//
//  UserAnnotation.h
//  SoonZik
//
//  Created by LLC on 30/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "User.h"
#import "Music.h"

@interface UserAnnotation : NSObject <MKAnnotation>

//@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) User *artist;
@property (nonatomic, strong) Music *music;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord user:(User *)user music:(Music *)music artist:(User *)artist;

@end
