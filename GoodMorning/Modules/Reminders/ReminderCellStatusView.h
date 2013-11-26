//
//  ReminderCellStatusView.h
//  GoodMorning
//
//  Created by Felix Santiago on 11/3/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderCellStatusView : UIView

@property(nonatomic, getter=isCompleted) BOOL completed;
@property(nonatomic) CGColorRef completedColor;

@end
