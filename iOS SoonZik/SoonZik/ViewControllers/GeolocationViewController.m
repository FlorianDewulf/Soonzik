//
//  GeolocationViewController.m
//  SoonZik
//
//  Created by LLC on 30/06/2014.
//  Copyright (c) 2014 Coordina. All rights reserved.
//

#import "GeolocationViewController.h"
#import "ArtistViewController.h"
#import "UserAnnotation.h"
#import "UserListen.h"
#import "UsersController.h"
#import "AlbumViewController.h"
#import "ConcertsController.h"

#define METERS_PER_MILE 1609.344

#define DEGREES_RADIANS(angle) (angle / 180.0 * M_PI)

@interface GeolocationViewController ()

@end

@implementation GeolocationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:false withAnimation:UIStatusBarAnimationNone];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    self.areaSlider.minimumValue = 0.5;
    self.areaSlider.maximumValue = 10;
    self.areaSlider.value = 0.5;
    [self.areaSlider addTarget:self action:@selector(getAllOtherUsers) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.backBarButtonItem.title = @"";
    
    self.userPosition = [[CLLocationManager alloc] init];
    self.userPosition.delegate = self;
    self.userPosition.distanceFilter = kCLDistanceFilterNone;
    self.userPosition.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.userPosition respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.userPosition requestWhenInUseAuthorization];
    }
    
    [self getUserLocation];
    
    [self getAllOtherUsers];
    
    [self.detailView setFrame:CGRectMake(0, self.view.frame.size.height - self.detailView.frame.size.height, self.detailView.frame.size.width, self.detailView.frame.size.height)];
    [self.view addSubview:self.detailView];
    
    [self.myPositionButton addTarget:self action:@selector(getUserLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.detailView setAlpha:0];
    UITapGestureRecognizer *reco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToAlbumView:)];
    [self.detailView addGestureRecognizer:reco];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"last location : %@", [locations lastObject]);
    CLLocation *location = [locations lastObject];
    
    CLLocationCoordinate2D zoomLocation = location.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 2 * METERS_PER_MILE, 2 * METERS_PER_MILE);
    [UIView animateWithDuration:0.8 animations:^{
        [self.mapView setRegion:viewRegion];
    }];
    
    [self.userPosition stopUpdatingLocation];
}

- (void)getUserLocation
{
    NSLog(@"get location");
    [self.userPosition startUpdatingLocation];
    
    NSLog(@"size : %f", self.areaSlider.value*1000);
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    CLLocation *loca = [[CLLocation alloc] initWithLatitude:self.userPosition.location.coordinate.latitude longitude:self.userPosition.location.coordinate.longitude];
    
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:loca.coordinate radius:(int)self.areaSlider.value*1000];
    [self.mapView addOverlay:circle];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKCircleRenderer *circle = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
    circle.fillColor = [UIColor blueColor];
    circle.strokeColor = [UIColor redColor];
    circle.alpha = 0.2;
    circle.lineWidth = 1;
    
    return circle;
}

- (void)getAllOtherUsers
{
    //self.listOfListenings = [UsersController getUsersInArea:self.userPosition.location.coordinate.latitude :self.userPosition.location.coordinate.longitude :(int)self.areaSlider.value];
    
    
    
    [self getUserLocation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
        //this block runs on a background thread; Do heavy operation here
        self.listOfListenings = [UsersController getUsersInArea:self.userPosition.location.coordinate.latitude :self.userPosition.location.coordinate.longitude :(int)self.areaSlider.value];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This block runs on main thread, so update UI
            for (id annotation in self.mapView.annotations) {
                if ([annotation isKindOfClass:[UserAnnotation class]]) {
                    [self.mapView removeAnnotation:annotation];
                    NSLog(@"annotation");
                }
            }
            
            [self.mapView reloadInputViews];
            
            for (UserListen *listen in self.listOfListenings) {
                NSLog(@"found");
                CLLocationCoordinate2D coord;
                coord.latitude = listen.lat;
                coord.longitude = listen.lng;
                NSLog(@"user name : %@", listen.user.username);
                UserAnnotation *ann = [[UserAnnotation alloc] initWithCoordinate:coord user:listen.user music:listen.music artist:listen.artist];
                [self.mapView addAnnotation:ann];
            }
        });
    });
}

/// LE KREMLIN BICETRE
//48.829974, 2.362233




- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"customIdentifier";
    MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    } else {
        annotationView.annotation = annotation;
    }
    
    annotationView.canShowCallout = NO;
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        UIImage *img = [UIImage imageNamed:@"user_location.png"];
        CGSize newSize = CGSizeMake(30, 30);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        annotationView.image = newImage;
    } else {
        UIImage *img = [UIImage imageNamed:@"other_location.png"];
        CGSize newSize = CGSizeMake(30, 30);
        UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
        [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        annotationView.image = newImage;
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if (![view.annotation isKindOfClass:[MKUserLocation class]]) {
        UserAnnotation *userAnnot = (UserAnnotation *)view.annotation;
        
        self.userListenMusic = userAnnot.music;
        
        self.userLabel.text = userAnnot.user.username;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),  ^{
            //this block runs on a background thread; Do heavy operation here
            NSString *urlImage = [NSString stringWithFormat:@"%@assets/albums/%@", API_URL, userAnnot.music.albumImage];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlImage]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //This block runs on main thread, so update UI
                self.albumImage.image = [UIImage imageWithData:imageData];
            });
        });
        
        self.trackLabel.text = userAnnot.music.title;
        

        if (self.detailView.alpha == 0) {
            [UIView animateWithDuration:1 animations:^{
                [self.mapView setFrame:CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, self.mapView.frame.size.height - self.detailView.frame.size.height)];
                [self.detailView setAlpha:1];
            }];
        }
        
    }
    
    CLLocationCoordinate2D zoomLocation = view.annotation.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 1 * METERS_PER_MILE, 1 * METERS_PER_MILE);
    
    [UIView animateWithDuration:0.8 animations:^{
        [self.mapView setRegion:viewRegion];
    }];
}

- (void)goToAlbumView:(UITapGestureRecognizer *)reco
{
    NSLog(@"tap");
    AlbumViewController *vc = [[AlbumViewController alloc] initWithNibName:@"AlbumViewController" bundle:nil];
    vc.album = [[Album alloc] init];
    vc.album.identifier = self.userListenMusic.albumId;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }
}

@end
