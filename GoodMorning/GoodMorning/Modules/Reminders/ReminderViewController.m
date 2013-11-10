//
//  ReminderViewController.m
//  GoodMorning
//
//  Created by Felix Santiago on 10/27/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "ReminderViewController.h"
#import "ReminderSettingsViewController.h"
#import "ReminderCell.h"

NSString * const ReminderSettingsChangeNotification = @"ReminderSettingsChangeNotification";

@interface ReminderViewController () <EKEventEditViewDelegate>

// EKEventStore instance associated with the current Reminder application
@property (nonatomic, strong) EKEventStore *eventStore;
@property(nonatomic, strong) EKCalendar *defaultReminderCalendar;

// Array of all reminders in a list
@property (nonatomic, strong) NSMutableArray *reminders;
@property (nonatomic, strong) NSArray *availableReminderCalendars;
@property (nonatomic, strong) NSMutableArray *displayedReminderCalendars;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ReminderSettingsViewController *reminderSettingsVC;

- (void)setup;
- (void)refresh;

@end

@implementation ReminderViewController

- (ReminderSettingsViewController *)reminderSettingsVC {
    if (!_reminderSettingsVC) {
        _reminderSettingsVC = [[ReminderSettingsViewController alloc] init];
    }
    return _reminderSettingsVC;
}

- (ShowRemindersType)type {
        if (!_type) {
                _type = ShowAll;
        }
    return _type;
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
	// Initialize the event store
	self.eventStore = [[EKEventStore alloc] init];

    // Add in our custom cell
    UINib *reminderCellNib = [UINib nibWithNibName:@"ReminderCell" bundle:nil];
    [self.tableView registerNib:reminderCellNib forCellReuseIdentifier:@"reminderCell"];

    // Set the table inset
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 10);

    // Add an empty footer
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    // Check whether we are authorized to access Reminders
    [self checkEventStoreAccessForReminder];
}

#pragma mark -
#pragma mark TableViewDelegate Functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reminders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EKReminder *reminder = [self.reminders objectAtIndex:(NSUInteger) indexPath.row];

    ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reminderCell" forIndexPath:indexPath];
    cell.reminder = reminder;
    return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    ReminderCell *cell = (ReminderCell *) [tableView cellForRowAtIndexPath:indexPath];
    cell.reminder.completed = !cell.reminder.completed;
    [self.eventStore saveReminder:cell.reminder commit:YES error:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadData];
}

#pragma mark -
#pragma mark Access Reminders

// Check the authorization status of our application for Reminders
-(void)checkEventStoreAccessForReminder {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    
    switch (status)
    {
        // Update our UI if the user has granted access to their Reminders
        case EKAuthorizationStatusAuthorized: [self accessGrantedForReminder];
            break;
            // Prompt the user for access to Reminders if there is no definitive answer
        case EKAuthorizationStatusNotDetermined: [self requestReminderAccess];
            break;
            // Display a message if the user has denied or restricted access to Reminders
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Privacy Warning" message:@"Permission was not granted for Reminders"
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

// Prompt the user for access to their Reminders
-(void)requestReminderAccess {
    [self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             // Let's ensure that our code will be executed from the main queue
             dispatch_async(dispatch_get_main_queue(), ^{
                 // The user has granted access to their Reminders; let's populate our UI with all events occurring in the next 24 hours.
                 [self accessGrantedForReminder];
             });
         }
     }];
}

// This method is called when the user has granted permission to their Reminders
-(void)accessGrantedForReminder {
    // Let's get the default calendar associated with our event store
    self.defaultReminderCalendar = self.eventStore.defaultCalendarForNewReminders;
    self.availableReminderCalendars = [[self.eventStore calendarsForEntityType:EKEntityTypeReminder] mutableCopy];

    // Fetch all reminders
    [self fetchReminders];
}

#pragma mark -
#pragma mark Fetch events

- (void)fetchReminders {
    [self setupValues];
    if (self.displayedReminderCalendars.count == 0) {
        self.reminders = [@[] mutableCopy];
        return;
    }
    // Fetch only incomplete reminders
    NSPredicate *predicate;
    switch (self.type) {
        case ShowAll:{
            predicate = [self.eventStore predicateForRemindersInCalendars:self.displayedReminderCalendars];
            break;
        }
        case ShowIncomplete: {
            predicate = [self.eventStore predicateForIncompleteRemindersWithDueDateStarting:nil ending:nil calendars:self.displayedReminderCalendars];
            break;
        }
        case ShowComplete: {
            predicate = [self.eventStore predicateForCompletedRemindersWithCompletionDateStarting:nil ending:nil calendars:self.displayedReminderCalendars];
            break;
        }
        default: {
            predicate = [self.eventStore predicateForIncompleteRemindersWithDueDateStarting:nil ending:nil calendars:self.displayedReminderCalendars];
            break;
        }
    }
//    predicate = [self.eventStore predicateForRemindersInCalendars:self.displayedReminderCalendars];
    [self.eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {
        self.reminders = [NSMutableArray arrayWithArray:reminders] ;
        if ([self.reminders count] == 0) {
            [self createFakeReminders];
            self.type = ShowAll;
            [self performSelectorOnMainThread:@selector(fetchReminders) withObject:nil waitUntilDone:YES];
        }
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:YES] ;
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        self.reminders = [[self.reminders sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }];
}

- (void)createFakeReminders {
    NSArray *sampleReminderTitles = @[@"Finish App", @"???", @"Profit", @"Get milk"];

    for (int i = 0; i < sampleReminderTitles.count; i++) {
        NSString *name  = [sampleReminderTitles objectAtIndex:(NSUInteger) i];
        EKReminder *reminder = [EKReminder reminderWithEventStore:self.eventStore];
        reminder.title = name;
        reminder.calendar = self.defaultReminderCalendar;
        reminder.completed = i == 0 ? YES : NO;
        reminder.priority =  sampleReminderTitles.count - i;
        [self.eventStore saveReminder:reminder commit:NO error:nil];
    }
    self.type = ShowAll;
    [self.eventStore commit:nil];

}

#pragma mark -
#pragma mark Add a new reminder

// Display an event edit view controller when the user taps the "+" button.
// A new event is added to Calendar when the user taps the "Done" button in the above view controller.
- (IBAction)addEvent:(id)sender {
    // Create an instance of EKEventEditViewController
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] init];

    // Set addController's event store to the current event store
    addController.eventStore = self.eventStore;
    addController.editViewDelegate = self;
    [self presentViewController:addController animated:YES completion:nil];
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
                // Re-fetch all events happening in the next 24 hours
                [self fetchReminders];
                // Update the UI with the above events
//                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            });
        }
    }];
}

// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
    return self.defaultReminderCalendar;
}

- (void)showSettings {
    self.reminderSettingsVC.availableReminderCalendars = self.availableReminderCalendars;
    self.reminderSettingsVC.displayedReminderCalendars = self.displayedReminderCalendars;
    self.reminderSettingsVC.type = self.type;
    [self presentViewController:self.reminderSettingsVC animated:YES completion:nil];
}

#pragma mark -
#pragma mark Private Methods

- (void)setup {
    // Initialize the event store
    self.eventStore = [[EKEventStore alloc] init];
    // Initialize the events list
    self.reminders = [[NSMutableArray alloc] initWithCapacity:0];

    // Listen for outside calendar updates
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:EKEventStoreChangedNotification
                                               object:self.eventStore];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refresh)
                                                 name:ReminderSettingsChangeNotification
                                               object:nil];

}

- (void)setupValues {
    NSDictionary *reminderDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"reminderKey"];
    if (!reminderDict) {
        // If we don't have anything just show the default calendar
        self.displayedReminderCalendars = [@[self.defaultReminderCalendar] mutableCopy];
        self.type = ShowAll;
    } else {
        NSMutableArray *savedCalendars = [NSMutableArray arrayWithCapacity:[reminderDict[@"displayedReminderCalendars"] count]];
        for ( NSString *identifier in reminderDict[@"displayedReminderCalendars"] ) {
            [savedCalendars addObject: [self.eventStore calendarWithIdentifier:identifier]];
        }
        self.displayedReminderCalendars = savedCalendars;
        self.type = (ShowRemindersType) [reminderDict[@"displayReminderType"] intValue];
    }
}

- (void)refresh {
    self.reminders = [@[] mutableCopy];
    [self.tableView reloadData];
    self.availableReminderCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];
    [self fetchReminders];
}


- (NSString *)headerTitle {
    return @"Reminders";
}

- (UIColor *)headerColor {
    return [UIColor colorWithRed:1.f green:141/255.0 blue:78/255.0 alpha:1.f];
}

- (SEL)settingsSelector {
    return @selector(showSettings);
}

- (SEL)addSelector {
    return @selector(addEvent:);
}

- (NSString *)moduleScript {
    NSMutableArray *incompleteReminders = [[NSMutableArray alloc] initWithCapacity:0];
    for (EKReminder *reminder in self.reminders) {
        if (!reminder.isCompleted) {
            [incompleteReminders addObject:reminder];
        }
    }
    if (incompleteReminders.count == 0) {
        return @"You have no tasks to do today.";
    }
    return [[NSString alloc] initWithFormat:@"You have %d tasks to do.", incompleteReminders.count];
}

@end
