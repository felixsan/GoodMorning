//
//  ReminderSettingsViewController.h
//  GoodMorning
//
//  Created by Felix Santiago on 10/27/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderModel.h"

@interface ReminderSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)ReminderModel *rm;

@end
