//
//  CountdownView.h
//  GoodMorning
//
//  Created by Felix Santiago on 10/23/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownView : UIView

@property (nonatomic, weak) IBOutlet UILabel *timeLeft;
@property (nonatomic, weak) IBOutlet UILabel *eventName;

@end
