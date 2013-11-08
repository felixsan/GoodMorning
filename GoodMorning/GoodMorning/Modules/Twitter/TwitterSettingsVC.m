//
//  TwitterSettingsVC.m
//  GoodMorning
//
//  Created by Ben Lindsey on 11/7/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "TwitterSettingsVC.h"
#import "TwitterClient.h"

NSString * const TwitterAccountChangedNotification = @"TwitterAccountChangedNotification";

@interface TwitterSettingsVC ()

@property (weak, nonatomic) IBOutlet UIPickerView *accountPicker;

- (IBAction)onOkayButton;

@end

@implementation TwitterSettingsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationPageSheet;
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *accounts = [[TwitterClient instance] accounts];
    ACAccount *account = [[TwitterClient instance] account];
    NSUInteger row = [accounts indexOfObject:account];

    [self.accountPicker reloadComponent:0];
    [self.accountPicker selectRow:row inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, 722, 413);
}

#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[[TwitterClient instance] accounts] count];
}

#pragma mark - UIPickerView Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *accounts = [[TwitterClient instance] accounts];
    ACAccount *account = accounts[row];
    return account.accountDescription;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *accounts = [[TwitterClient instance] accounts];
    ACAccount *account = accounts[row];
    [[TwitterClient instance] setAccount:account];
}

#pragma mark - Private methods

- (IBAction)onOkayButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TwitterAccountChangedNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
