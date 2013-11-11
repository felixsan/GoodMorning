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
    CLLocation *_lastLocation;
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
    [self postNotification];
}

- (void)stopUpdatingLocation
{
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _lastLocation = [locations lastObject];
    [self postNotification];
}

#pragma mark - Private methods

- (void)postNotification
{
    if (_lastLocation) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LocationDidChangeNotification object:_lastLocation];
    }
}

@end
