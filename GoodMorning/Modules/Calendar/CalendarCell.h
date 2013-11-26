//
//  CalendarCell.h
//  GoodMorning
//
//  Created by Felix Santiago on 11/3/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface CalendarCell : UITableViewCell

@property (strong, nonatomic) EKEvent *event;

@end
