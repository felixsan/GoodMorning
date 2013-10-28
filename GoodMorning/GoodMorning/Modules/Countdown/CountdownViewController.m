//
// Created by Felix Santiago on 10/25/13.
// Copyright (c) 2013 MakeItRain. All rights reserved.
//


#import "CountdownViewController.h"
#import "CountdownSettingsViewController.h"
#import "CountdownView.h"

@interface CountdownViewController ()

@property (nonatomic, strong) CountdownSettingsViewController *countdownSettingsVC;

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

}

- (void)updateTime:(NSTimer *)timer {
    NSDictionary *timeLeft = self.cm.getTimeLeft;
    NSLog(@"timeLeft - %@, %@", timeLeft[CountdownAmount], timeLeft[CountdownGranularity]);

    // Set the time
    CountdownView *cv = (CountdownView *)self.view;
    BOOL isPast = [timeLeft[CountdownAmount] intValue] == 0 && [timeLeft[CountdownGranularity] isEqualToString:@""];
    cv.timeLeft.text = !isPast ? [timeLeft[CountdownAmount] stringValue] : @"😃" ;
    cv.eventName.text = !isPast ? [NSString stringWithFormat:@"%@ till %@!", timeLeft[CountdownGranularity], self.cm.eventName] : [NSString stringWithFormat:@"%@!", self.cm.eventName];

}

- (IBAction)showSettings:(id)sender {
    NSLog(@"Showing the settings");
    self.countdownSettingsVC.cm = self.cm;
    [self presentViewController:self.countdownSettingsVC
                       animated:YES
                     completion:nil];

//    [UIView transitionWithView:self.countdownSettingsVC.view
//                      duration:1
//                       options:UIViewAnimationOptionTransitionFlipFromRight
//                    animations:^{
//                        [[[self.view subviews] objectAtIndex:0] removeFromSuperview],
//                                [self.view addSubview:self.countdownSettingsVC.view];
//                    }
//                    completion:^(BOOL finished){
//
//                    }];
//    [UIView transitionFromView:self.view
//                        toView:self.countdownSettingsVC.view
//                      duration:1
//                       options:UIViewAnimationOptionTransitionFlipFromRight
//                    completion:nil];

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
        [components setDay:6];
        [components setMonth:11];
        [components setYear:2013];
        [components setHour:21];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *date = [gregorian dateFromComponents:components];
        self.cm  = [CountdownModel initWithName:@"Class ends" date:date];
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


@end