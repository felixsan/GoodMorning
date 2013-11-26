//
//  CalendarListCell.m
//  GoodMorning
//
//  Created by Felix Santiago on 11/3/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "CalendarListCell.h"
#import "CalendarColorView.h"

@interface CalendarListCell ()

@property (weak, nonatomic) IBOutlet UILabel *calendarName;
@property (weak, nonatomic) IBOutlet CalendarColorView *colorView;

@end

@implementation CalendarListCell

- (void)setCalendar:(EKCalendar *)calendar {
    _calendar = calendar;
    self.calendarName.text = calendar.title;
    self.colorView.calendarColor = calendar.CGColor;

}


@end
