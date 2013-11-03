//
//  CalendarListCell.h
//  GoodMorning
//
//  Created by Felix Santiago on 11/3/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *calendarName;
@property (nonatomic, getter=isChosen) BOOL chosen;

@end
