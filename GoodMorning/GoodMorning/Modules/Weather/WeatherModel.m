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

@end


@implementation WeatherModel

- (id)initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        // Current conditions
        NSDictionary *currently = data[@"currently"];
        self.currently = [[Forecast alloc] initWithDictionary:currently];
        
        // Hourly forecasts for up next day
        self.hourly = [[NSMutableArray alloc] init];
        NSArray *hourly = [data valueForKeyPath:@"hourly.data"];
        for (NSDictionary *hourlyDict in hourly) {
            [self.hourly addObject:[[Forecast alloc] initWithDictionary:hourlyDict]];
        }
        
        // Daily forecasts for up to next ten days
        self.daily = [[NSMutableArray alloc] init];
        NSArray *daily = [data valueForKeyPath:@"daily.data"];
        for (NSDictionary *dailyDict in daily) {
            [self.daily addObject:[[Forecast alloc] initWithDictionary:dailyDict]];
        }
    }

    return self;
}

- (double)high {
    return ((Forecast *)self.daily[0]).temperatureMax;
}

- (double)low {
    return ((Forecast *)self.daily[0]).temperatureMin;
}

@end
