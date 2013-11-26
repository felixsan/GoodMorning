//
//  HourlyForecastView.h
//  GoodMorning
//
//  Created by Ben on 10/27/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HourlyForecastView : UIView

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@end
