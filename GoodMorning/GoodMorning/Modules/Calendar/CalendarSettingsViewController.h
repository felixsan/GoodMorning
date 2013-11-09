//
//  CalendarSettingsViewController.h
//  GoodMorning
//
//  Created by Felix Santiago on 11/1/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSArray *availableCalendars;
@property (nonatomic, strong)NSMutableArray *displayedCalendars;

@end
