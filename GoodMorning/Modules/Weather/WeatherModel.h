//
//  WeatherModel.h
//  GoodMorning
//
//  Created by Ben on 10/23/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Forecast.h"

@interface WeatherModel : NSObject

@property (strong, nonatomic) Forecast *currently;
@property (strong, nonatomic) NSMutableArray *hourly;
@property (strong, nonatomic) NSMutableArray *daily;
@property (strong, nonatomic) NSString *location;
@property (nonatomic, readonly) double high;
@property (nonatomic, readonly) double low;
@property (strong, nonatomic) NSString *summary;

- (id)initWithDictionary:(NSDictionary *)data;

- (NSArray *)keyHours;

@end
