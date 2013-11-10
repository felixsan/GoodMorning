//
//  ReminderViewController.h
//  GoodMorning
//
//  Created by Felix Santiago on 10/27/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "ModuleController.h"

typedef enum ShowRemindersType {
    ShowAll,
    ShowIncomplete,
    ShowComplete
} ShowRemindersType;

extern NSString *const ReminderSettingsChangeNotification;

@interface ReminderViewController : ModuleController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableViewCell *reminderCell;
@property (nonatomic) ShowRemindersType type;

@end
