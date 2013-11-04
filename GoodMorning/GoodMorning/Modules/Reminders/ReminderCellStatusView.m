//
//  ReminderCellStatusView.m
//  GoodMorning
//
//  Created by Felix Santiago on 11/3/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "ReminderCellStatusView.h"

@interface ReminderCellStatusView ()
@end

@implementation ReminderCellStatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);

    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    CGRect rectangle = CGRectMake(5.0, 5.0, 25.0, 25.0);
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, rectangle);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    if (self.isCompleted) {
        CGRect smallRect = CGRectInset(rectangle, 3, 3);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetFillColorWithColor(context, self.completedColor);
        CGContextBeginPath(context);
        CGContextAddEllipseInRect(context, smallRect);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    UIGraphicsEndImageContext();
}

@end
