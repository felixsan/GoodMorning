//
//  ModuleHeaderView.h
//  GoodMorning
//
//  Created by Felix Santiago on 10/31/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModuleHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (nonatomic, strong) NSString *title;

@end
