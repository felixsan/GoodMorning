//
//  DevelopmentVC.m
//  GoodMorning
//
//  Created by Ben on 10/26/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "DevelopmentVC.h"
#import "WeatherViewController.h"

@interface DevelopmentVC ()

@end

@implementation DevelopmentVC

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
    [self addModules];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addModules {
    WeatherViewController *weather = [[WeatherViewController alloc] init];
    [self addChildViewController:weather];
    weather.view.frame = CGRectMake(10, 75, 1004, 222);
    [self.view addSubview:weather.view];
    [weather didMoveToParentViewController:self];
}

@end
