//
//  WeatherView.h
//  GoodMorning
//
//  Created by Ben on 10/23/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherView : UIView

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@end
