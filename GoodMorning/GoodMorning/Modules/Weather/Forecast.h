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
@property (nonatomic) double precipIntensity;
@property (nonatomic) double precipProbability;
@property (nonatomic) double temperature;
@property (nonatomic) double apparentTemperature;
@property (nonatomic) double dewPoint;
@property (nonatomic) double windSpeed;
@property (nonatomic) double windBearing;
@property (nonatomic) double cloudCover;
@property (nonatomic) double humidity;
@property (nonatomic) double pressure;
@property (nonatomic) double floatfloatVisibility;
@property (nonatomic) double floatozone;
@property (nonatomic) double temperatureMax;
@property (nonatomic) double temperatureMin;

- (id)initWithDictionary:(NSDictionary *)data;


@end
