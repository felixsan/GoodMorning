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
#import "CreditsView.h"

@interface WeatherViewController ()

@property (strong, nonatomic) WeatherModel *weather;
@property (strong, nonatomic) NSString *curWeatherState;
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

- (WeatherModel *)weather {
    if (!_weather) {
        _weather = [[WeatherModel alloc] initWithDictionary:@{}];
    }
    return _weather;
}

- (NSString *)curWeatherState {
    if (!_curWeatherState) {
        _curWeatherState = @"";
    } else if ([_curWeatherState  isEqual: @"Drizzle"]) {
        return @"drizzling";
    } else if ([_curWeatherState  isEqual: @"Rain"]) {
        return @"raining";
    }
    return _curWeatherState;
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
    weatherView.locationLabel.text = @"Current Location";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:LocationDidChangeNotification object:nil];
    [[LocationManager instance] startUpdatingLocation];
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
    self.curWeatherState = self.weather.currently.summary;
    weatherView.temperatureLowLabel.text = [NSString stringWithFormat:@"%1.f", self.weather.low];
    weatherView.temperatureHighLabel.text = [NSString stringWithFormat:@"%1.f", self.weather.high];
    weatherView.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.weather.currently.icon]];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"h:mm a"];
    
    float count = 0;
    for (Forecast *hour in [self.weather keyHours]) {
        if (count >= 15) {
            break;
        }
        CGRect frame = CGRectMake(count*150, 0, 150, 222);
        HourlyForecastView *hourlyView = [[HourlyForecastView alloc] initWithFrame:frame];
        hourlyView.temperatureLabel.text = [NSString stringWithFormat:@"%1.f", hour.temperature];
        hourlyView.timeLabel.text = [outputFormatter stringFromDate:[hour getTime]];
        hourlyView.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", hour.icon]];
        [weatherView.hourlyScrollView addSubview:hourlyView];
        count += 1; //150;
    }
    CGRect frame = CGRectMake(count*150, 0, 200, 222);
    CreditsView *creditsView = [[CreditsView alloc] initWithFrame:frame];
    [weatherView.hourlyScrollView addSubview:creditsView];
    weatherView.hourlyScrollView.contentSize = CGSizeMake((count*150) + 200, 222);
}

- (void)locationUpdated:(NSNotification *)notification
{
    CLLocation* location = notification.object;
    [self loadWeatherWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    //[self.locationManager stopUpdatingLocation];

//    [[WeatherAPI instance] addressWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        id codes = [JSON objectForKey:@"postalCodes"];
//        if ([codes isKindOfClass:[NSArray class]]) {
//            NSDictionary *location = [codes lastObject];
//            WeatherView *view = (WeatherView *)self.view;
//            self.weather.location = [location objectForKey:@"placeName"];
//            view.locationLabel.text = [NSString stringWithFormat:@"%@, %@", self.weather.location, [location objectForKey:@"adminCode1"]];
//        }
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
//        NSLog(@"%@", error);
//    }];
}

- (void)loadWeatherWithLatitude:(double)latitude longitude:(double)longitude {
    [[WeatherAPI instance] forecastWithLatitude:latitude longitude:longitude success:^(AFHTTPRequestOperation *operation, id response) {
        self.weather = [[WeatherModel alloc] initWithDictionary:response];
        [self updateView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
}

- (NSString *)moduleScript {
    NSString *curWeather = self.curWeatherState;
//    NSString *chanceOfRain = @"";
//    NSString *location = self.weather.location;
    NSString *curTemp = [[NSString alloc] initWithFormat:@"%1.f degrees", self.weather.currently.temperature];
    NSString *highTemp = [[NSString alloc] initWithFormat:@"%1.f degrees", self.weather.high];
    NSString *lowTemp = [[NSString alloc] initWithFormat:@"%1.f degrees", self.weather.low];
    return [[NSString alloc] initWithFormat:@"It is currently %@ and %@.  It will be %@  with a high of %@ and a low of %@. ", curWeather, curTemp, self.weather.summary, highTemp, lowTemp];
}

//- (void)didMoveToParentViewController:(UIViewController *)parent {
//    [super didMoveToParentViewController:parent];
//    [self updateView];
//}

@end
