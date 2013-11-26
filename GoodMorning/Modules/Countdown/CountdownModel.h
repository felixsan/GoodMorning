//
//  CountdownModel.h
//  GoodMorning
//
//  Created by Felix Santiago on 10/23/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

extern NSString *const CountdownAmount;
extern NSString *const CountdownGranularity;

@interface CountdownModel : NSObject

@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSString *eventName;

+ (CountdownModel *)initWithName:(NSString *)name date:(NSDate *)endDate;
- (NSDictionary *)getTimeLeft;
- (BOOL)isCountdownCompleted;

@end
