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
@property (nonatomic, readonly) double high;
@property (nonatomic, readonly) double low;

- (id)initWithDictionary:(NSDictionary *)data;

@end
