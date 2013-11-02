//
//  ReminderModel.m
//  GoodMorning
//
//  Created by Felix Santiago on 10/27/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "ReminderModel.h"

@implementation ReminderModel

- (ShowRemindersType)type {
    if (!_type) {
        _type = ShowIncomplete;
    }

    return _type;
}

@end
