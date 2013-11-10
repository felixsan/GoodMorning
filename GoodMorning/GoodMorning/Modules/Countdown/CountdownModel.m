//
//  CountdownModel.m
//  GoodMorning
//
//  Created by Felix Santiago on 10/23/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "CountdownModel.h"

NSString *const CountdownAmount = @"CountdownAmount";
NSString *const CountdownGranularity = @"CountdownGranularity";

@implementation CountdownModel

+ (CountdownModel *)initWithName:(NSString *)name date:(NSDate *)endDate {
    CountdownModel *cm = [[CountdownModel alloc] init];
    cm.eventName = name;
    cm.endDate = endDate;
    return cm;
}

- (NSDictionary *)getTimeLeft {
    NSDate *now = [NSDate date];
    int secondsLeft = (int) [self.endDate timeIntervalSinceDate: now] ;
    int days    = (secondsLeft / (3600 * 24));
    int hours   = (secondsLeft/ 3600)- (days *24);
    int minutes = secondsLeft % 3600 / 60;
    int result;
    NSString *granularity;
    // Todo look at pluralization stuff
    if (days >= 1) {
        result = days;
        granularity = @"Day";
    } else if (hours >= 1) {
        result = hours;
        granularity = @"Hour";
    } else if (minutes >= 1) {
        result = minutes;
        granularity = @"Minute";
    } else if (secondsLeft >= 1) {
        result = secondsLeft;
        granularity = @"Second";
    } else {
        result = 0;
        granularity = @"";
    }

    if (result != 1 && ![granularity isEqualToString:@""]) {
        granularity = [granularity stringByAppendingString:@"s"];
    }

    return @{CountdownAmount: @(result), CountdownGranularity: granularity};
}

- (BOOL)isCountdownCompleted {
    NSDictionary *timeLeft = [self getTimeLeft];
    return [timeLeft[CountdownAmount] isEqual:@(0)];
}

@end
