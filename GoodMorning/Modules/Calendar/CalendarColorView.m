//
//  CalendarColorView.m
//  GoodMorning
//
//  Created by Felix Santiago on 11/4/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "CalendarColorView.h"

@implementation CalendarColorView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.calendarColor);
    CGContextSetLineWidth(context, 0.0);

    CGRect rectangle = CGRectMake(0.0, 0.0, 15.0, 15.0);
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextDrawPath(context, kCGPathFillStroke);

    UIGraphicsEndImageContext();
}

@end
