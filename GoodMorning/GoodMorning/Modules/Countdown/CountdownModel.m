//
//  CountdownModel.m
//  GoodMorning
//
//  Created by Felix Santiago on 10/23/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "CountdownModel.h"

@implementation CountdownModel

- (NSString *)getTimeLeft {
    NSDate *now = [NSDate date];
    int secondsLeft = (int) [self.endDate timeIntervalSinceDate: now] ;
    int days    = (secondsLeft / (3600 * 24));
    int hours   = (secondsLeft/ 3600)- (days *24);
    int minutes = secondsLeft % 3600 / 60;

    // Todo look at pluralization stuff
    if (days > 1) {
        return [NSString stringWithFormat:@"%01d Days",days];
    } else if (days == 1) {
        return [NSString stringWithFormat:@"%01d Day",days];
    }

    if (hours > 1) {
        return [NSString stringWithFormat:@"%01d Hours",hours];
    } else if (days == 1) {
        return [NSString stringWithFormat:@"%01d Hour",hours];
    }

    if (minutes > 1) {
        return [NSString stringWithFormat:@"%01d Minutes",minutes];
    } else if (minutes == 1) {
        return [NSString stringWithFormat:@"%01d Minute",minutes];
    } else {
        return [NSString stringWithFormat:@"%01d Minutes",minutes];
    }
}

@end
