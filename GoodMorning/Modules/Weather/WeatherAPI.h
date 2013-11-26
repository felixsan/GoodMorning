//
//  WeatherAPI.h
//  GoodMorning
//
//  Created by Ben on 10/23/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "AFHTTPClient.h"

@interface WeatherAPI : AFHTTPClient

+ (WeatherAPI *)instance;

- (void)forecastWithLatitude:(float)latitude longitude:(float)longitude success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)addressWithLatitude:(float)latitude longitude:(float)longitude success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end
