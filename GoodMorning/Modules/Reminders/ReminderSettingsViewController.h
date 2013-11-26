//
//  ReminderSettingsViewController.h
//  GoodMorning
//
//  Created by Felix Santiago on 10/27/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderViewController.h"

@interface ReminderSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *availableReminderCalendars;
@property (nonatomic, strong) NSMutableArray *displayedReminderCalendars;
@property (nonatomic) ShowRemindersType type;

@end
