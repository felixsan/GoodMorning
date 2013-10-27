//
//  WeatherModel.m
//  GoodMorning
//
//  Created by Ben on 10/23/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "WeatherModel.h"
#import "Forecast.h"

@interface WeatherModel ()

@property (strong, nonatomic) Forecast *currently;
@property (strong, nonatomic) NSMutableArray *hourly;

@end


@implementation WeatherModel

- (id)initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        NSDictionary *currently = data[@"currently"];
        self.currently = [[Forecast alloc] initWithDictionary:currently];
    }

    return self;
}

@end
