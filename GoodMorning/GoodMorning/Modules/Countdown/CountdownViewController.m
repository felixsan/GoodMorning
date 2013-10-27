//
// Created by Felix Santiago on 10/25/13.
// Copyright (c) 2013 MakeItRain. All rights reserved.
//


#import "CountdownViewController.h"
#import "CountdownSettingsViewController.h"

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
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)showSettings:(id)sender {
    NSLog(@"Showing the settings");
    [self presentViewController:self.countdownSettingsVC
                       animated:YES
                     completion:nil];

//    [UIView transitionWithView:self.tutorialView
//                      duration:0.4
//                       options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionCurveEaseInOut
//                    animations:^{
//                        [[[self.tutorialView subviews] objectAtIndex:0] removeFromSuperview],
//                                [self.tutorialView addSubview:infoView.view];
//                    }
//                    completion:^(BOOL finished){
//
//                    }];
}


@end