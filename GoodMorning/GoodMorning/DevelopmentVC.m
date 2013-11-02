//
//  DevelopmentVC.m
//  GoodMorning
//
//  Created by Ben on 10/26/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "DevelopmentVC.h"
#import "WeatherViewController.h"
#import "CountdownViewController.h"
#import "ReminderViewController.h"
#import "CalendarViewController.h"

@interface DevelopmentVC ()

@end

@implementation DevelopmentVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Good Morning";
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

    // Add Countdown View
    CountdownViewController *countdown = [[CountdownViewController alloc] init];
    [self addChildViewController:countdown];
    countdown.view.frame = CGRectMake(686, 535, 328, 222);
    [self.view addSubview:countdown.view];
    [countdown didMoveToParentViewController:self];

    // Adding the Reminders panel
    ReminderViewController *reminders = [[ReminderViewController alloc] init];
    [self addChildViewController:reminders];
    reminders.view.frame = CGRectMake(686, 305, 328, 222);
    [self.view addSubview:reminders.view];
    [reminders didMoveToParentViewController:self];

    // Adding the Calendar panel
    CalendarViewController *calendar = [[CalendarViewController alloc] init];
    [self addChildViewController:calendar];
    calendar.view.frame = CGRectMake(348, 305, 328, 222);
    [self.view addSubview:calendar.view];
    [calendar didMoveToParentViewController:self];


}

@end
