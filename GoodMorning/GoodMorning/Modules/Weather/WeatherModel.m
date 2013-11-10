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

- (NSString *)location {
    if (!_location) {
        _location = @"";
    }
    return _location;
}

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

- (NSArray *)keyHours {
    NSDictionary *reference_hours = @{
        @"6:00 AM" : @"1",
        @"8:00 AM" : @"1",
        @"10:00 AM" : @"1",
        @"12:00 PM" : @"1",
        @"3:00 PM" : @"1",
        @"5:00 PM" : @"1",
        @"7:00 PM" : @"1",
        @"12:00 AM" : @"1",
        @"2:00 AM" : @"1",
        @"4:00 AM" : @"1",
    };
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];

    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (Forecast *hour in self.hourly) {
        NSString *time = [outputFormatter stringFromDate:[hour getTime]];
        if ([reference_hours objectForKey:time] != nil) {
            [results addObject:hour];
        }
    }
    return results;
}

@end
