//
//  CalendarCell.m
//  GoodMorning
//
//  Created by Felix Santiago on 11/3/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "CalendarCell.h"

@interface CalendarCell ()

@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *eventCalendar;
@property (weak, nonatomic) IBOutlet UILabel *eventCalendarColor;

@end

@implementation CalendarCell

- (void)setEvent:(EKEvent *)event {
    _event = event;


    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];

    self.eventTime.text = [formatter stringFromDate:[event startDate]];
    self.eventName.text = event.title;
    self.eventLocation.text = event.location;
    self.eventCalendar.text = event.calendar.title;
//    self.eventCalendarColor = event.calendar.CGColor;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
