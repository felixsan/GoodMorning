//
//  LocationManager.h
//  GoodMorning
//
//  Created by Ben Lindsey on 11/6/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString *const LocationDidChangeNotification;

@interface LocationManager : NSObject <CLLocationManagerDelegate>

+ (LocationManager *)instance;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
