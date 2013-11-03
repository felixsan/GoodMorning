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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addStyleToView:self.view];
    
}

- (void)addStyleToView:(UIView *)view {
    view.layer.shadowOffset = CGSizeMake(2, 2);
    view.layer.shadowColor = [[UIColor grayColor] CGColor];
    view.layer.shadowRadius = 3.0f;
    view.layer.shadowOpacity = 0.7f;
}

@end
