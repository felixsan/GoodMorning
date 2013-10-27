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
        self.summary = data[@"summary"];
    }
    
    return self;
}

@end
