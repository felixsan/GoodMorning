//
//  AuthorizationViewController.h
//  GoodMorning
//
//  Created by Ben on 11/25/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "ModuleController.h"

extern NSString *const AuthorizationGrantedNotification;

@interface AuthorizationViewController : ModuleController

@property NSString *title;
@property UIColor *color;
@property NSString *type;

- (id)initWithType:(NSString *)type title:(NSString *) title color:(UIColor *)color;

@end
