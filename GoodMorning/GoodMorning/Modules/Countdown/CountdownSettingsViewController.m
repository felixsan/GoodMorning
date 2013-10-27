//
// Created by Felix Santiago on 10/27/13.
// Copyright (c) 2013 MakeItRain. All rights reserved.
//


#import "CountdownSettingsViewController.h"


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

- (IBAction)cancelDateChange:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)saveDateChange:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];

}

@end