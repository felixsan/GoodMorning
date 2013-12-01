//
//  AuthorizationViewController.m
//  GoodMorning
//
//  Created by Ben on 11/25/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "AuthorizationViewController.h"

NSString * const AuthorizationGrantedNotification = @"AuthorizationGrantedNotification";

@interface AuthorizationViewController ()

- (IBAction)onEnable:(id)sender;

@end

@implementation AuthorizationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithType:(NSString *)type title:(NSString *)title color:(UIColor *)color {
    self = [super init];
    self.title = title;
    self.color = color;
    self.type = type;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)headerTitle
{
    return self.title;
}

- (UIColor *)headerColor
{
    return self.color;
}

- (IBAction)onEnable:(id)sender {
    if ([self.type isEqualToString:@"calendar"]) {
        [self requestCalendarAccess];
    } else if ([self.type isEqualToString:@"reminders"]) {
        [self requestRemindersAccess];
    } else if ([self.type isEqualToString:@"twitter"]) {
        [self requestTwitterAccess];
    }
}

- (void)requestCalendarAccess {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:AuthorizationGrantedNotification object:self];
             });
         }
     }];
}

- (void)requestRemindersAccess {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:AuthorizationGrantedNotification object:self];
             });
         }
     }];
}

- (void)requestTwitterAccess {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:AuthorizationGrantedNotification object:self];
             });
         }
     }];
}
@end
