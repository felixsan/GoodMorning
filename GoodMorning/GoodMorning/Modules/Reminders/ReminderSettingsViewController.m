//
//  ReminderSettingsViewController.m
//  GoodMorning
//
//  Created by Felix Santiago on 10/27/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "ReminderSettingsViewController.h"

@interface ReminderSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)cancel:(id)sender;
- (IBAction)saveChanges:(id)sender;

@end

@implementation ReminderSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // For ios 6 and below use the PresentationPage Sheet
        self.modalPresentationStyle = UIModalPresentationPageSheet;
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        // For ios 7 use the custom presentation that flips over
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    ReminderSettingsView *rsv = (ReminderSettingsView *)self.view;
//    rsv.rm = self.rm;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ReminderListCell"];

    // Add an empty footer
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];


}

- (void)viewWillLayoutSubviews{
    NSLog(@"view will layout");
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0,0,722, 413);
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)saveChanges:(id)sender {
//    ReminderSettingsView *rsv = (ReminderSettingsView *)self.view;
//    self.rm.endDate = rsv.eventDate.date;
//    self.rm.eventName = rsv.eventName.text;
//    [[NSUserDefaults standardUserDefaults] setObject:@{@"name": self.cm.eventName, @"date": self.cm.endDate} forKey:@"countdownKey"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES  completion:nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"I got asked the count");
    return [self.rm.reminderLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderListCell" forIndexPath:indexPath];

    // Get the event at the row selected and display its title
    cell.textLabel.text = [[self.rm.reminderLists objectAtIndex:(NSUInteger) indexPath.row] title];
    NSLog(@"Title - %@", cell.textLabel.text);
    return cell;
}

@end
