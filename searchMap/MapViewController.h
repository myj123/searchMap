//
//  MapViewController.h
//  searchMap
//
//  Created by Ibokan on 14-4-21.
//  Copyright (c) 2014年 孟延军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView * _mapView;
    CLLocationManager * _locManager;
}

@property(strong,nonatomic)NSString * country;

@property(strong,nonatomic)NSString * province;

@property(strong,nonatomic)NSString * city;

@end
