//
// Created by Felix Santiago on 10/25/13.
// Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleController.h"
#import "CountdownModel.h"

extern NSString *const NewEventRequestedNotification;

@interface CountdownViewController : ModuleController

@property (nonatomic, strong)NSTimer *countdownTimer;
@property (nonatomic, strong)CountdownModel *cm;

- (void)initCountdown;

- (void)updateTime:(NSTimer *)timer;
@end