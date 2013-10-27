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
#import "WeatherViewController.h"

@interface WeatherViewController ()

@property WeatherModel *weather;

@end

@implementation WeatherViewController

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
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView {
    WeatherView *weatherView = (WeatherView *)self.view;
    weatherView.temperatureLabel.text = [NSString stringWithFormat:@"%f", self.weather.currently.temperature];
    weatherView.summaryLabel.text = self.weather.currently.summary;
}

@end
