//
//  Forecast.m
//  GoodMorning
//
//  Created by Ben on 10/25/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "Forecast.h"

@implementation Forecast

- (id)initWithDictionary:(NSDictionary *)data {
    if (self = [super init]) {
        self.time = [data[@"time"] integerValue];
        self.summary = data[@"summary"];
        self.icon = data[@"icon"];
        self.temperature = [data[@"temperature"] doubleValue];
        self.temperatureMax = [data[@"temperatureMax"] doubleValue];
        self.temperatureMin = [data[@"temperatureMin"] doubleValue];
    }
    
    return self;
}

- (NSDate *)getTime {
    return [NSDate dateWithTimeIntervalSince1970:self.time];
}

@end
