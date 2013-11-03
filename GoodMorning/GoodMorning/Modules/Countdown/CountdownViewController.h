//
// Created by Felix Santiago on 10/25/13.
// Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "CountdownModel.h"

@interface CountdownViewController : UIViewController

@property (nonatomic, strong)NSTimer *countdownTimer;
@property (nonatomic, strong)CountdownModel *cm;

- (void)initCountdown;

- (IBAction)showSettings:(id)sender;

- (void)updateTime:(NSTimer *)timer;
@end