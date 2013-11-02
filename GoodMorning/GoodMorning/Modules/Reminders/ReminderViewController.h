//
//  ReminderViewController.h
//  GoodMorning
//
//  Created by Felix Santiago on 10/27/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReminderModel.h"

@interface ReminderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableViewCell *reminderCell;
@property (nonatomic, strong) ReminderModel *rm;

- (IBAction)showSettings:(id)sender;

@end
