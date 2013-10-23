//
//  WeatherAPI.m
//  GoodMorning
//
//  Created by Ben on 10/23/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "WeatherAPI.h"

#define API_KEY = "fabdcf23b63418fe5b70732b24653a62"
#define BASE_WEATHER_URL = [NSUrl URLWithString:[NSString stringWithFormat: @"https://api.forecast.io/forecast/%@/"]]

@implementation WeatherAPI

- (void)forecastWithLatitude:(float)latitude longitude:(float)longitude success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self getPath:[NSString stringWithFormat:@"%f,%f", latitude, longitude] parameters:nil success:success failure:failure];
}

@end
