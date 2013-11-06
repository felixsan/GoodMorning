//
//  TrafficViewController.m
//  GoodMorning
//
//  Created by Ben Lindsey on 10/31/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "TrafficViewController.h"
#import <MapKit/MapKit.h>

@interface TrafficViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation TrafficViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locationManager.distanceFilter = 500; // meters

    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"html"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *html = [NSString stringWithFormat:content, latitude, longitude];
    
    [self.webView loadHTMLString:html baseURL:nil];
}

- (NSString *)headerTitle
{
    return @"Traffic";
}

- (UIColor *)headerColor
{
    return [UIColor colorWithRed:154.0/255 green:2.0/255 blue:143.0/255  alpha:1.f];
}

@end
