//
//  CalendarViewController.h
//  GoodMorning
//
//  Created by Felix Santiago on 11/1/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleController.h"

extern NSString *const CalendarSettingsChangeNotification;
extern NSString *const NewEventDetectedNotification;

@interface CalendarViewController : ModuleController <UITableViewDelegate, UITableViewDataSource>

@end
