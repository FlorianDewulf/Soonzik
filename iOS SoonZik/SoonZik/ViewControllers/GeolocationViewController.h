//
//  GeolocationViewController.h
//  SoonZik
//
//  Created by LLC on 30/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "TypeViewController.h"
#import "Music.h"
#import <MapKit/MapKit.h>

@interface GeolocationViewController : TypeViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UIView *detailView;

@property (nonatomic, strong) NSMutableArray *listOfListenings;
@property (nonatomic, strong) NSMutableArray *listOfConcerts;

@property (nonatomic, strong) IBOutlet UIButton *myPositionButton;

@property (nonatomic, strong) CLLocationManager *userPosition;

@property (nonatomic, strong) IBOutlet UILabel *userLabel;
@property (nonatomic, strong) IBOutlet UIImageView *albumImage;
@property (nonatomic, strong) IBOutlet UILabel *trackLabel;

@property (nonatomic, strong) IBOutlet UISlider *areaSlider;

@property (nonatomic, strong) Music *userListenMusic;

@end
