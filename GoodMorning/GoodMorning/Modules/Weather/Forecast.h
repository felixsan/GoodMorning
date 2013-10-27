//
//  Forecast.h
//  GoodMorning
//
//  Created by Ben on 10/25/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Forecast : NSObject

@property (weak, nonatomic) NSDate *time;
@property (weak, nonatomic) NSString *summary;
@property (weak, nonatomic) NSString *icon;
@property (nonatomic) float precipIntensity;
@property (nonatomic) float precipProbability;
@property (nonatomic) float temperature;
@property (nonatomic) float apparentTemperature;
@property (nonatomic) float dewPoint;
@property (nonatomic) float windSpeed;
@property (nonatomic) float windBearing;
@property (nonatomic) float cloudCover;
@property (nonatomic) float humidity;
@property (nonatomic) float pressure;
@property (nonatomic) float floatfloatVisibility;
@property (nonatomic) float floatozone;

- (id)initWithDictionary:(NSDictionary *)data;


@end
