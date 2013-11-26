//
//  SettingsViewController.h
//  GoodMorning
//
//  Created by Ben Lindsey on 11/9/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ModuleAddedNotification;
extern NSString *const ModuleRemovedNotification;

@interface SettingsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@end
