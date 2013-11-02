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

@interface WeatherViewController ()

@property WeatherModel *weather;

@end

@implementation WeatherViewController

+ (NSUInteger)rows
{
    return 1;
}

+ (NSUInteger)cols
{
    return 3;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[WeatherAPI instance] forecastWithLatitude:37.7806 longitude:-121.9904 success:^(AFHTTPRequestOperation *operation, id response) {
//            NSLog(response);
            self.weather = [[WeatherModel alloc] initWithDictionary:response];
            [self updateView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // Do nothing
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    WeatherView *weatherView = (WeatherView *)self.view;
//    weatherView.layer.borderColor = [UIColor blackColor].CGColor;
//    weatherView.layer.borderWidth = 1.0f;
//    weatherView.layer.shadowOffset = CGSizeMake(2, 2);
//    weatherView.layer.shadowColor = [[UIColor blackColor] CGColor];
//    weatherView.layer.shadowRadius = 4.0f;
//    weatherView.layer.shadowOpacity = 1.0f;
//    weatherView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:weatherView.layer.bounds] CGPath];
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
    weatherView.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"png/%@", self.weather.currently.icon]];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    
    float offset = 0;
    for (Forecast *hour in [self.weather keyHours]) {
        CGRect frame = CGRectMake(offset, 0, 150, 222);
        HourlyForecastView *hourlyView = [[HourlyForecastView alloc] initWithFrame:frame];
        hourlyView.temperatureLabel.text = [NSString stringWithFormat:@"%1.f", hour.temperature];
        hourlyView.timeLabel.text = [outputFormatter stringFromDate:hour.time];
        hourlyView.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"png/%@", hour.icon]];
        [weatherView.hourlyScrollView addSubview:hourlyView];
        offset += 150;
    }
    weatherView.hourlyScrollView.contentSize = CGSizeMake(offset+150, 222);
}

@end
