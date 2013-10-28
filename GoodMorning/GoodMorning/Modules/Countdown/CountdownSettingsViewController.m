//
// Created by Felix Santiago on 10/27/13.
// Copyright (c) 2013 MakeItRain. All rights reserved.
//


#import "CountdownSettingsViewController.h"
#import "CountdownSettingsView.h"
#import "CountdownViewController.h"


@interface CountdownSettingsViewController ()

- (IBAction)cancelDateChange:(id)sender;
- (IBAction)saveDateChange:(id)sender;

@end

@implementation CountdownSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // For ios 6 and below use the PresentationPage Sheet
        self.modalPresentationStyle = UIModalPresentationPageSheet;
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        // For ios 7 use the custom presentation that flips over
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CountdownSettingsView *csv = (CountdownSettingsView *)self.view;
    [csv.eventDate setDate:self.cm.endDate];
    csv.eventName.text = self.cm.eventName;
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0,0,722, 413);
}

- (IBAction)cancelDateChange:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)saveDateChange:(id)sender {
    CountdownSettingsView *csv = (CountdownSettingsView *)self.view;
    self.cm.endDate = csv.eventDate.date;
    self.cm.eventName = csv.eventName.text;
    [[NSUserDefaults standardUserDefaults] setObject:@{@"name": self.cm.eventName, @"date": self.cm.endDate} forKey:@"countdownKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES  completion:nil];

}

@end