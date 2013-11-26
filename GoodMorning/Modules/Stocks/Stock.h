//
//  Stock.h
//  GoodMorning
//
//  Created by Ben Lindsey on 11/10/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stock : NSObject

@property (strong, nonatomic) NSString *symbol;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *last;
@property (strong, nonatomic) NSString *change;

@property (strong, nonatomic) NSString *open;
@property (strong, nonatomic) NSString *high;
@property (strong, nonatomic) NSString *low;
@property (strong, nonatomic) NSString *volume;
@property (strong, nonatomic) NSString *PE;

@property (strong, nonatomic) NSString *marketCap;
@property (strong, nonatomic) NSString *yearHigh;
@property (strong, nonatomic) NSString *yearLow;
@property (strong, nonatomic) NSString *averageVolume;
@property (strong, nonatomic) NSString *yield;

@end
