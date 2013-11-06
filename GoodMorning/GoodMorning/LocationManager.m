//
//  LocationManager.m
//  GoodMorning
//
//  Created by Ben Lindsey on 11/6/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "LocationManager.h"

NSString * const LocationDidChangeNotification = @"LocationDidChangeNotification";

@implementation LocationManager {
    CLLocationManager *_locationManager;
}

+ (LocationManager *)instance
{
    static dispatch_once_t once;
    static LocationManager *instance;

    dispatch_once(&once, ^{
        instance = [[LocationManager alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.distanceFilter = 500; // meters
    }
    return self;
}

- (void)startUpdatingLocation
{
    [_locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    NSLog(@"lat:%f long:%f", location.coordinate.latitude, location.coordinate.longitude);
    [[NSNotificationCenter defaultCenter] postNotificationName:LocationDidChangeNotification object:location];
}

@end
