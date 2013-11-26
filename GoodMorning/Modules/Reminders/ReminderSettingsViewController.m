//
//  ReminderSettingsViewController.m
//  GoodMorning
//
//  Created by Felix Santiago on 10/27/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "CalendarListCell.h"
#import "ReminderSettingsViewController.h"
#import "ReminderViewController.h"
#import "ReminderSettingsView.h"

@interface ReminderSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)cancel:(id)sender;
- (IBAction)saveChanges:(id)sender;

@end

@implementation ReminderSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // For ios 6 and below use the PresentationPage Sheet
        self.modalPresentationStyle = UIModalPresentationPageSheet;
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        // For ios 7 use the custom presentation that flips over
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add in our custom cell
    UINib *calendarListCellNib = [UINib nibWithNibName:@"CalendarListCell" bundle:nil];
    [self.tableView registerNib:calendarListCellNib forCellReuseIdentifier:@"ReminderListCell"];

    // Set the table inset
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 10);
        
    // Add an empty footer
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0 , 540, 244);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.availableReminderCalendars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EKCalendar *calendar = [self.availableReminderCalendars objectAtIndex:(NSUInteger) indexPath.row];
    CalendarListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReminderListCell" forIndexPath:indexPath];
    cell.accessoryType = [self.displayedReminderCalendars containsObject:calendar] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.calendar = calendar;
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    CalendarListCell *cell = (CalendarListCell *) [tableView cellForRowAtIndexPath:indexPath];
    if ([self.displayedReminderCalendars containsObject:cell.calendar]) {
        [self.displayedReminderCalendars removeObject:cell.calendar];
    } else {
        [self.displayedReminderCalendars addObject:cell.calendar];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadData];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveChanges:(id)sender {
//    NSLog(@"displayed reminder calendars - %@", self.displayedCalendars);
    NSMutableArray *savedCalendars = [NSMutableArray arrayWithCapacity:self.displayedReminderCalendars.count];
    for ( EKCalendar *calendar in self.displayedReminderCalendars) {
        [savedCalendars addObject: [calendar calendarIdentifier]];
    }
    ReminderSettingsView *settingsView = (ReminderSettingsView *) self.view;
    [[NSUserDefaults standardUserDefaults] setObject:@{@"displayedReminderCalendars": savedCalendars, @"displayReminderType": [NSNumber numberWithInteger:settingsView.reminderType.selectedSegmentIndex]} forKey:@"reminderKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:ReminderSettingsChangeNotification object:nil];
    [self dismissViewControllerAnimated:YES  completion:nil];
}

@end
