//
//  ModuleController.m
//  GoodMorning
//
//  Created by Ben Lindsey on 10/28/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "ModuleController.h"

@interface ModuleController ()

@end

@implementation ModuleController

- (NSUInteger)rows
{
    return 1;
}

- (NSUInteger)cols
{
    return 1;
}

- (NSString *)headerTitle
{
    return nil;
}

- (UIColor *)headerColor
{
    return [UIColor lightGrayColor];
}

- (SEL)settingsSelector
{
    return nil;
}

- (SEL)addSelector
{
    return nil;
}

- (NSString *)moduleScript {
    return @"";
}

@end
