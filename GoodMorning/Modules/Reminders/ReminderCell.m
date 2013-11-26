//
//  ReminderCell.m
//  GoodMorning
//
//  Created by Felix Santiago on 11/3/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "ReminderCell.h"
#import "ReminderCellStatusView.h"

@interface ReminderCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet ReminderCellStatusView *statusView;
@property (nonatomic, getter=isCompleted) BOOL completed;

@end

@implementation ReminderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setReminder:(EKReminder *)reminder {
    _reminder = reminder;
    NSDictionary *mainTextAttributes;
    self.completed = reminder.isCompleted;
    self.statusView.completed = reminder.isCompleted;
    self.statusView.completedColor = reminder.calendar.CGColor;
    if (reminder.isCompleted) {
        mainTextAttributes = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)};
    } else {
        mainTextAttributes = @{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleNone)};
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:reminder.title attributes: mainTextAttributes];

    self.title.attributedText = str;
    [self.statusView setNeedsDisplay];
}

@end
