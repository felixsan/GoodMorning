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
@property (weak, nonatomic) IBOutlet UILabel *temperatureHighLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLowLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *hourlyScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIView *creditsView;
@property (weak, nonatomic) IBOutlet UIButton *apiCreditRequest;

- (IBAction)iconCreditRequest:(id)sender;
- (IBAction)apiCreditRequest:(id)sender;

@end
