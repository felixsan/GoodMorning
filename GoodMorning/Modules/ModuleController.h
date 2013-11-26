//
//  ModuleController.h
//  GoodMorning
//
//  Created by Ben Lindsey on 10/28/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModuleController : UIViewController

- (NSUInteger)rows;
- (NSUInteger)cols;

- (NSString *)headerTitle;
- (UIColor *)headerColor;
- (SEL)settingsSelector;
- (SEL)addSelector;
- (NSString *)moduleScript;

@end
