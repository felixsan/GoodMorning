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

@property (weak, nonatomic) IBOutlet UIWebView *webView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];

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

- (void)locationUpdated:(NSNotification *)notification
{
    CLLocation* location = notification.object;
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
