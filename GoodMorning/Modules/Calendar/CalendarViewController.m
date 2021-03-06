//
//  CalendarViewController.m
//  GoodMorning
//
//  Created by Felix Santiago on 11/1/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "CalendarViewController.h"
#import "CalendarCell.h"
#import "CalendarSettingsViewController.h"
#import "ReminderViewController.h"
#import "CountdownViewController.h"

NSString * const CalendarSettingsChangeNotification = @"CalendarSettingsChangeNotification";
NSString * const NewEventDetectedNotification = @"NewEventDetectedNotification";

@interface CalendarViewController () <EKEventEditViewDelegate>

// EKEventStore instance associated with the current Calendar application
@property (nonatomic, strong) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours
@property (nonatomic, strong) NSMutableArray *eventsList;

@property (nonatomic, strong) NSArray *availableCalendars;
@property (nonatomic, strong) NSMutableArray *displayedCalendars;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) CalendarSettingsViewController *calendarSettings;

- (void)setup;
- (void)refresh;
- (void)presentCalendarEditModalWith:(EKEvent *)event;

@end

@implementation CalendarViewController

- (NSMutableArray *)displayedCalendars {
    return _displayedCalendars;
}

- (CalendarSettingsViewController *)calendarSettings {
    if (!_calendarSettings) {
        _calendarSettings = [[CalendarSettingsViewController alloc] init];
    }
    return _calendarSettings;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add in our custom cell
    UINib *calendarCellNib = [UINib nibWithNibName:@"CalendarCell" bundle:nil];
    [self.tableView registerNib:calendarCellNib forCellReuseIdentifier:@"eventCell"];

    // Check whether we are authorized to access Reminders
    [self checkEventStoreAccessForCalendar];

    // Add an empty footer
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchForNewEvents:) name:NewEventRequestedNotification object:nil];
}

#pragma mark -
#pragma mark TableViewDelegate Functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get the event at the row selected and display its title
    EKEvent *event = [self.eventsList objectAtIndex:(NSUInteger) indexPath.row];

    CalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    cell.event = event;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Get the event at the row selected and present the edit event modal
    EKEvent *event = [self.eventsList objectAtIndex:(NSUInteger) indexPath.row];
    [self presentCalendarEditModalWith:event];
}

#pragma mark -
#pragma mark Access Calendar

// Check the authorization status of our application for Calendar
- (void)checkEventStoreAccessForCalendar {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];

    switch (status)
    {
        // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized: [self accessGrantedForCalendar];
            break;
            // Prompt the user for access to Calendar if there is no definitive answer
        case EKAuthorizationStatusNotDetermined: [self requestCalendarAccess];
            break;
            // Display a message if the user has denied or restricted access to Calendar
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Calendar"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

// Prompt the user for access to their Calendar
- (void)requestCalendarAccess {
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
    {
        if (granted)
        {
            // Let's ensure that our code will be executed from the main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                // The user has granted access to their Calendar; let's populate our UI with all events occurring in the next 24 hours.
                [self accessGrantedForCalendar];
            });
        }
    }];
}

// This method is called when the user has granted permission to Calendar
- (void)accessGrantedForCalendar {
    // Let's get the default calendar associated with our event store
    self.defaultCalendar = self.eventStore.defaultCalendarForNewEvents;

    // Set the visible calendars
    // Check to see if we have a countdown defined in the UserDefaults
    NSDictionary *calendarDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"calendarKey"];
    if (!calendarDict) {
        // If we don't have anything just show the default calendar
        self.displayedCalendars = [@[self.defaultCalendar] mutableCopy];
    } else {
        NSMutableArray *savedCalendars = [NSMutableArray arrayWithCapacity:[calendarDict[@"displayedCalendars"] count]];
        for ( NSString *identifier in calendarDict[@"displayedCalendars"] ) {
            [savedCalendars addObject: [self.eventStore calendarWithIdentifier:identifier]];
        }
        self.displayedCalendars  = savedCalendars;
    }
    [self refresh];
}

#pragma mark -
#pragma mark Fetch events

// Fetch all events happening in the next 24 hours
- (NSMutableArray *)fetchEvents {

    if (self.displayedCalendars.count == 0) {
        return [@[] mutableCopy];
    }
    NSDate *startDate = [NSDate date];

    //Create the end date components
    NSDateComponents *tomorrowDateComponents = [[NSDateComponents alloc] init];
    tomorrowDateComponents.day = 1;

    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:tomorrowDateComponents
                                                                    toDate:startDate
                                                                   options:0];
    // Create the predicate
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                      endDate:endDate
                                                                    calendars:self.displayedCalendars];
    // Fetch all events that match the predicate
    NSMutableArray *events = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
    return events;
}

// Looking for new events for the next 90 days.
- (void)searchForNewEvents:(NSNotification *)notification {
    if (self.displayedCalendars.count == 0) {
        return;
    }
    NSDate *startDate = [NSDate date];
    
    //Create the end date components
    NSDateComponents *tomorrowDateComponents = [[NSDateComponents alloc] init];
    tomorrowDateComponents.day = 90;
    
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:tomorrowDateComponents
                                                                    toDate:startDate
                                                                   options:0];
    // Create the predicate
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                      endDate:endDate
                                                                    calendars:self.displayedCalendars];
    // Fetch all events that match the predicate
    NSMutableArray *events = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
    for (EKEvent *event in events) {
        if ([event.title isEqualToString:@"Vacation"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NewEventDetectedNotification object:event];
        }
    }
}

#pragma mark -
#pragma mark Add a new event

// Display an event edit view controller when the user taps the "+" button.
// A new event is added to Calendar when the user taps the "Done" button in the above view controller.
- (IBAction)addEvent:(id)sender {
    [self presentCalendarEditModalWith:nil];
}

#pragma mark -
#pragma mark EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action {
    // Dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:^
    {
        if (action != EKEventEditViewActionCanceled)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refresh];
            });
        }
    }];
}

// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
    return self.defaultCalendar;
}

#pragma mark -
#pragma mark Private Methods

- (void)setup {

    // Initialize the event store
    self.eventStore = [[EKEventStore alloc] init];
    // Initialize the events list
    self.eventsList = [[NSMutableArray alloc] initWithCapacity:0];

    // Listen for outside calendar updates
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:EKEventStoreChangedNotification
                                               object:self.eventStore];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:CalendarSettingsChangeNotification
                                               object:nil];
}

- (void)refresh {
//    NSLog(@"Refresh called");
    self.availableCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
    self.eventsList = [self fetchEvents];
    [self searchForNewEvents:nil];
    // Update the UI with the above events
    [self.tableView reloadData];
}

- (void)presentCalendarEditModalWith:(EKEvent *)event {
    // Create an instance of EKEventEditViewController
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] init];

    // Set addController's event store to the current event store
    addController.eventStore = self.eventStore;
    addController.editViewDelegate = self;
    if (event) {
        addController.event = event;
    }
    [self presentViewController:addController animated:YES completion:nil];
}

- (void)showSettings {
    self.calendarSettings.availableCalendars = self.availableCalendars;
    self.calendarSettings.displayedCalendars = self.displayedCalendars;
    [self presentViewController:self.calendarSettings animated:YES completion:nil];
}

- (NSString *)headerTitle {
    static NSDateFormatter *formatter;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEEE MMMM d";
    }
    return [formatter stringFromDate:[NSDate date]];
}

- (UIColor *)headerColor {
    return [UIColor colorWithRed:205.0/255 green:62.0/255 blue:64.0/255 alpha:1.f];
}

- (SEL)settingsSelector {
    return @selector(showSettings);
}

- (SEL)addSelector {
    return @selector(addEvent:);
}

- (NSString *)moduleScript {
    if (self.eventsList.count == 0) {
        return @"You have no events scheduled for today.  ";
    }
    EKEvent *firstEvent = self.eventsList.firstObject;
    static NSDateFormatter *formatter;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterShortStyle;
    }
    NSString *preface = self.eventsList.count > 3 ? @"You have a busy day today." : @"";
    NSString *startTime = [formatter stringFromDate:firstEvent.startDate];
    NSString *eventsString = self.eventsList.count == 1 ? @"event" : @"events";
    NSString *locationString = [firstEvent.location length] != 0 ? [[NSString alloc] initWithFormat:@"at %@", firstEvent.location] : @"";
    return [[NSString alloc] initWithFormat:@"%@ You have %d upcoming %@.  Your first one, %@ %@, starts at %@ .  ", preface, self.eventsList.count, eventsString, firstEvent.title, locationString, startTime];
}

@end
