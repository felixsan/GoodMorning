//
//  WeatherViewController.m
//  GoodMorning
//
//  Created by Ben on 10/26/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "WeatherAPI.h"
#import "WeatherModel.h"
#import "WeatherView.h"
#import "HourlyForecastView.h"
#import "WeatherViewController.h"
#import "LocationManager.h"

@interface WeatherViewController ()

@property WeatherModel *weather;

@end

@implementation WeatherViewController

- (NSUInteger)rows
{
    return 1;
}

- (NSUInteger)cols
{
    return 3;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    WeatherView *weatherView = (WeatherView *)self.view;
    weatherView.locationLabel.text = @"";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:LocationDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView {
    WeatherView *weatherView = (WeatherView *)self.view;
    weatherView.temperatureLabel.text = [NSString stringWithFormat:@"%1.f", self.weather.currently.temperature];
    weatherView.summaryLabel.text = self.weather.currently.summary;
    weatherView.temperatureLowLabel.text = [NSString stringWithFormat:@"%1.f", self.weather.low];
    weatherView.temperatureHighLabel.text = [NSString stringWithFormat:@"%1.f", self.weather.high];
    weatherView.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.weather.currently.icon]];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    
    float offset = 0;
    for (Forecast *hour in [self.weather keyHours]) {
        CGRect frame = CGRectMake(offset, 0, 150, 222);
        HourlyForecastView *hourlyView = [[HourlyForecastView alloc] initWithFrame:frame];
        hourlyView.temperatureLabel.text = [NSString stringWithFormat:@"%1.f", hour.temperature];
        hourlyView.timeLabel.text = [outputFormatter stringFromDate:[hour getTime]];
        hourlyView.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", hour.icon]];
        [weatherView.hourlyScrollView addSubview:hourlyView];
        offset += 150;
    }
    weatherView.hourlyScrollView.contentSize = CGSizeMake(offset, 222);
}

- (void)locationUpdated:(NSNotification *)notification
{
    CLLocation* location = notification.object;
    [self loadWeatherWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    //[self.locationManager stopUpdatingLocation];

    [[WeatherAPI instance] addressWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        id codes = [JSON objectForKey:@"postalCodes"];
        if ([codes isKindOfClass:[NSArray class]]) {
            NSDictionary *location = [codes lastObject];
            WeatherView *view = (WeatherView *)self.view;
            view.locationLabel.text = [NSString stringWithFormat:@"%@, %@", [location objectForKey:@"placeName"], [location objectForKey:@"adminCode1"]];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@", error);
    }];
}

- (void)loadWeatherWithLatitude:(double)latitude longitude:(double)longitude {
    [[WeatherAPI instance] forecastWithLatitude:latitude longitude:longitude success:^(AFHTTPRequestOperation *operation, id response) {
        self.weather = [[WeatherModel alloc] initWithDictionary:response];
        [self updateView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
}

@end
