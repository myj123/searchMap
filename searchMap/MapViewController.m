//
//  MapViewController.m
//  searchMap
//
//  Created by Ibokan on 14-4-21.
//  Copyright (c) 2014年 孟延军. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"可用");
        
        _locManager = [[CLLocationManager alloc] init];
        _locManager.distanceFilter = 100;
        _locManager.desiredAccuracy =kCLLocationAccuracyBest;
        _locManager.delegate = self;
        
        [_locManager startUpdatingLocation];
        
        
    }
    else{
        NSLog(@"设备不可用");
    }
    CGRect rect = [[UIScreen mainScreen]bounds];
     _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, rect.origin.y, rect.size.width, rect.size.height)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    NSString * name = [self.province stringByAppendingString:self.city];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:name completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * p in placemarks) {
            NSLog(@"address = %@",p.addressDictionary);
        }
    }];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(39.9265, 116.4785);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.03f, 0.03f);
    _mapView.region = MKCoordinateRegionMake(coor, span);
    _mapView.showsUserLocation = YES;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
    [_mapView addAnnotation:annotation];
    [_mapView selectAnnotation:annotation animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    static NSString * identifier = @"map";
    
    __autoreleasing MKPinAnnotationView * view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    view.annotation = annotation;
    view.animatesDrop = YES;
    view.pinColor = MKPinAnnotationColorPurple;
    view.canShowCallout = YES;
    
    return view;
}

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations{
    for (CLLocation * loc in locations) {
        
        MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = loc.coordinate;
        [_mapView addAnnotation:annotation];
    }
    CLLocation * loc = [locations lastObject];
    _mapView.region = MKCoordinateRegionMake(loc.coordinate, MKCoordinateSpanMake(0.03, 0.03));
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
}


@end
