//
//  TrafficViewController.m
//  GoodMorning
//
//  Created by Ben Lindsey on 10/31/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "TrafficViewController.h"
#import "LocationManager.h"

@interface TrafficViewController ()

@end

@implementation TrafficViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated:) name:LocationDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 328, 192)];
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((328 - 100) / 2, 60, 100, 20);
        [button setTitle:@"Authorize" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(requestAccess) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    } else {
        [[LocationManager instance] startUpdatingLocation];
    }
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

- (void)locationUpdated:(NSNotification *)notification
{
    CLLocation* location = notification.object;
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;

    NSString *path = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"html"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSString *html = [NSString stringWithFormat:content, latitude, longitude];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 328, 192)];
    [webView loadHTMLString:html baseURL:nil];
    [self.view addSubview:webView];
}

- (NSString *)headerTitle
{
    return @"Traffic";
}

- (UIColor *)headerColor
{
    return [UIColor colorWithRed:154.0/255 green:2.0/255 blue:143.0/255  alpha:1.f];
}

- (void)requestAccess
{
    [[LocationManager instance] startUpdatingLocation];
}

@end
