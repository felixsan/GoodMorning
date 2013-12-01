//
// Created by Felix Santiago on 10/25/13.
// Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "CountdownViewController.h"
#import "CountdownSettingsViewController.h"
#import "CountdownView.h"
#import "CalendarViewController.h"

NSString * const NewEventRequestedNotification = @"NewEventRequestedNotification";

@interface CountdownViewController ()

@property (nonatomic, strong) CountdownSettingsViewController *countdownSettingsVC;
@property (nonatomic, getter=isPast) BOOL past;


@end


@implementation CountdownViewController

- (CountdownSettingsViewController *)countdownSettingsVC {
    if (!_countdownSettingsVC) {
        _countdownSettingsVC = [[CountdownSettingsViewController alloc] init];
    }

    return _countdownSettingsVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCountdown];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newEventDetected:) name:NewEventDetectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NewEventRequestedNotification object:nil];

}

- (void)updateTime:(NSTimer *)timer {
    NSDictionary *timeLeft = self.cm.getTimeLeft;
//    NSLog(@"timeLeft - %@, %@", timeLeft[CountdownAmount], timeLeft[CountdownGranularity]);

    // Set the time
    CountdownView *cv = (CountdownView *)self.view;
    self.past = [timeLeft[CountdownAmount] intValue] == 0 && [timeLeft[CountdownGranularity] isEqualToString:@""];
    cv.timeLeft.text = !self.isPast ? [timeLeft[CountdownAmount] stringValue] : @"😃" ;
    cv.eventName.text = !self.isPast ? [NSString stringWithFormat:@"%@ until %@", timeLeft[CountdownGranularity], self.cm.eventName] : [NSString stringWithFormat:@"%@", self.cm.eventName];

}

- (void)showSettings {
    NSLog(@"Showing the settings");
    self.countdownSettingsVC.cm = self.cm;
    [self presentViewController:self.countdownSettingsVC animated:YES completion:nil];
}

- (void)initCountdown {
    CountdownView *cv = (CountdownView *)self.view;
    cv.timeLeft.text = @"";
    cv.eventName.text = @"";

    // Check to see if we have a countdown defined in the UserDefaults
    NSDictionary *countdownDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"countdownKey"];
    if (!countdownDict) {
        // Create a random one for the start of the last class
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setDay:11];
        [components setMonth:11];
        [components setYear:2013];
        [components setHour:19];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *date = [gregorian dateFromComponents:components];
        self.cm  = [CountdownModel initWithName:@"" date:date];
    } else {
        self.cm  = [CountdownModel initWithName:countdownDict[@"name"] date:countdownDict[@"date"]];
    }


    NSTimer *timer =  [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    self.countdownTimer = timer;

    if (self.countdownTimer != nil) {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:self.countdownTimer forMode:NSDefaultRunLoopMode];

    }
}

- (NSString *)headerTitle
{
    return @"Countdown";
}

- (UIColor *)headerColor
{
    return [UIColor colorWithRed:13.0/255 green:196.0/255 blue:83.0/255 alpha:1.f];
}

- (SEL)settingsSelector
{
    return @selector(showSettings);
}

- (NSString *)moduleScript {
    if (self.isPast) {
        return @"";
    }
    NSLog(@"%d", self.isPast);
    CountdownView *cv = (CountdownView *)self.view;
    NSString *verb = [cv.timeLeft.text isEqualToString:@"1"] ? @"is" : @"are";
    return [[NSString alloc] initWithFormat:@"There %@ %@ %@.  ", verb, cv.timeLeft.text, cv.eventName.text];
}

- (void)newEventDetected:(NSNotification *)notification {
    EKEvent *event = notification.object;
    if (self.cm == nil || [self.cm isCountdownCompleted]) {
        NSString *title = [NSString stringWithFormat:@"%@ in %@", event.title, event.location];
        self.cm  = [CountdownModel initWithName:title date:event.startDate];
    }
}

@end