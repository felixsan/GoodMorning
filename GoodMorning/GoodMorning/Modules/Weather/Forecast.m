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
        self.time = [NSDate dateWithTimeIntervalSince1970:[data[@"summary"] integerValue]];
        self.summary = data[@"summary"];
        self.icon = data[@"icon"];
        self.temperature = [data[@"temperature"] doubleValue];
    }
    
    return self;
}

@end
