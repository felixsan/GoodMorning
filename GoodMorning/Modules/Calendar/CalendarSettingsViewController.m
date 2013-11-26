//
//  CalendarSettingsViewController.m
//  GoodMorning
//
//  Created by Felix Santiago on 11/1/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "CalendarSettingsViewController.h"
#import "CalendarListCell.h"
#import "CalendarViewController.h"

@interface CalendarSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)cancel:(id)sender;
- (IBAction)saveChanges:(id)sender;

@end

@implementation CalendarSettingsViewController

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

    // Add in our custom cell
    UINib *calendarListCellNib = [UINib nibWithNibName:@"CalendarListCell" bundle:nil];
    [self.tableView registerNib:calendarListCellNib forCellReuseIdentifier:@"calendarCell"];

    // Set the table inset
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 10);

    // Add an empty footer
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0,0,722, 413);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.availableCalendars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the event at the row selected and display its title
    EKCalendar *calendar = [self.availableCalendars objectAtIndex:(NSUInteger) indexPath.row];
    CalendarListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"calendarCell" forIndexPath:indexPath];
    cell.accessoryType = [self.displayedCalendars containsObject:calendar] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.calendar = calendar;
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    CalendarListCell *cell = (CalendarListCell *) [tableView cellForRowAtIndexPath:indexPath];
    if ([self.displayedCalendars containsObject:cell.calendar]) {
        [self.displayedCalendars removeObject:cell.calendar];
    } else {
        [self.displayedCalendars addObject:cell.calendar];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadData];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveChanges:(id)sender {
//    NSLog(@"displayed calendars - %@", self.displayedCalendars);
    NSMutableArray *savedCalendars = [NSMutableArray arrayWithCapacity:self.displayedCalendars.count];
    for ( EKCalendar *calendar in self.displayedCalendars ) {
        [savedCalendars addObject: [calendar calendarIdentifier]];
    }

    [[NSUserDefaults standardUserDefaults] setObject:@{@"displayedCalendars": savedCalendars} forKey:@"calendarKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:CalendarSettingsChangeNotification object:nil];
    [self dismissViewControllerAnimated:YES  completion:nil];

}

@end
