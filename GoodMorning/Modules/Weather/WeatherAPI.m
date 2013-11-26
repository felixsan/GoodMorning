//
//  WeatherAPI.m
//  GoodMorning
//
//  Created by Ben on 10/23/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "WeatherAPI.h"
#import "AFNetworking.h"

#define API_KEY = "fabdcf23b63418fe5b70732b24653a62"
#define BASE_WEATHER_URL = [NSUrl URLWithString:[NSString stringWithFormat: @"https://api.forecast.io/forecast/%@/", API_KEY]];

@implementation WeatherAPI

+ (WeatherAPI *)instance {
    static dispatch_once_t once;
    static WeatherAPI *instance;
    
    dispatch_once(&once, ^{
        instance = [[WeatherAPI alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat: @"https://api.forecast.io/forecast/%s/", "fabdcf23b63418fe5b70732b24653a62"]]];
    });

    return instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self != nil) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

- (void)forecastWithLatitude:(float)latitude longitude:(float)longitude success:(void (^)(AFHTTPRequestOperation *operation, id response))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSString *path = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    [self getPath:path parameters:nil success:success failure:failure];
}

- (void)addressWithLatitude:(float)latitude longitude:(float)longitude success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))success failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure
{
    NSString *url = [NSString stringWithFormat:@"http://ws.geonames.org/findNearbyPostalCodesJSON?lat=%f&lng=%f", latitude, longitude];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:success failure:failure];
    [operation start];
}

@end
