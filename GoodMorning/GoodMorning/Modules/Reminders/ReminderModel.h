//
//  ReminderModel.h
//  GoodMorning
//
//  Created by Felix Santiago on 10/27/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

typedef enum ShowRemindersType {
    ShowAll,
    ShowIncomplete,
    ShowComplete
} ShowRemindersType;

@interface ReminderModel : NSObject

@property (strong, nonatomic) NSMutableArray *reminders;
@property (strong, nonatomic) NSArray *reminderLists;
@property (strong, nonatomic) EKCalendar *curReminderCalendar;
@property (nonatomic) ShowRemindersType type;


@end
