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

@interface ReminderViewController () <EKEventEditViewDelegate>

// EKEventStore instance associated with the current Reminder application
@property (nonatomic, strong) EKEventStore *eventStore;


// Array of all reminder lists available
@property (nonatomic, strong) NSArray *remindersLists;

// Array of all reminders in a list
@property (nonatomic, strong) NSMutableArray *reminders;

// Used to add a reminder
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) EKCalendar *currentReminderCalendar;

@property (nonatomic, strong) ReminderSettingsViewController *reminderSettingsVC;

@end

@implementation ReminderViewController

- (ReminderSettingsViewController *)reminderSettingsVC {
    if (!_reminderSettingsVC) {
        _reminderSettingsVC = [[ReminderSettingsViewController alloc] init];
    }

    return _reminderSettingsVC;
}


- (ReminderModel *)rm {
    if (!_rm) {
        _rm = [[ReminderModel alloc] init];
    }

    return _rm;
}

- (void)setRemindersLists:(NSArray *)remindersLists {
    _remindersLists = remindersLists;
    self.rm.reminderLists = remindersLists;
}

- (void)setCurrentReminderCalendar:(EKCalendar *)reminderCalendar {
    _currentReminderCalendar = reminderCalendar;
    self.rm.curReminderCalendar = reminderCalendar;
}

- (void)setReminders:(NSMutableArray *)reminders {
    _reminders = reminders;
    self.rm.reminders = reminders;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Initialize the event store
	self.eventStore = [[EKEventStore alloc] init];
    // Initialize the events list
//	self.remindersLists = [[NSMutableArray alloc] initWithCapacity:0];
    // The Add button is initially disabled
    self.addButton.enabled = NO;

    // Register our cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    // Check whether we are authorized to access Reminders
    [self checkEventStoreAccessForReminder];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

#pragma mark -
#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.currentReminderCalendar != nil) {
//        [self fetchRemindersFrom:self.currentReminderCalendar];
        NSLog(@"Table - %d", [self.reminders count]);
        return [self.reminders count];
    } else {
        return 0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    // Get the event at the row selected and display its title
    cell.textLabel.text = [[self.reminders objectAtIndex:(NSUInteger) indexPath.row] title];
    NSLog(@"Title - %@", cell.textLabel.text);
    return cell;
}


#pragma mark -
#pragma mark Access Reminders

// Check the authorization status of our application for Reminders
-(void)checkEventStoreAccessForReminder
{
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
-(void)requestReminderAccess
{
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
-(void)accessGrantedForReminder
{
    // Let's get the default calendar associated with our event store
    self.currentReminderCalendar = self.eventStore.defaultCalendarForNewReminders;
    self.remindersLists = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];
    NSLog(@"Default Reminders Calendar - %@", self.eventStore.defaultCalendarForNewReminders.title);
    // Enable the Add button
    self.addButton.enabled = YES;
    // Fetch all reminders
    [self fetchRemindersFrom:self.currentReminderCalendar];
    // Update the UI with the above reminders
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Fetch events

- (void)fetchRemindersFrom:(EKCalendar *)reminderCalendar {
    // Fetch only incomplete reminders
    NSPredicate *predicate;
    switch (self.rm.type) {
        case ShowAll:{
            predicate = [self.eventStore predicateForRemindersInCalendars:@[reminderCalendar]];
            break;
        }
        case ShowIncomplete: {
            predicate = [self.eventStore predicateForIncompleteRemindersWithDueDateStarting:nil ending:nil calendars:@[reminderCalendar]];
            break;
        }
        case ShowComplete: {
            predicate = [self.eventStore predicateForCompletedRemindersWithCompletionDateStarting:nil ending:nil calendars:@[reminderCalendar]];
            break;
        }
        default: {
            predicate = [self.eventStore predicateForIncompleteRemindersWithDueDateStarting:nil ending:nil calendars:@[reminderCalendar]];
            break;
        }
    }


    id reminderRequest = [self.eventStore fetchRemindersMatchingPredicate:predicate completion:^(NSArray *reminders) {
        self.reminders = [NSMutableArray arrayWithArray:reminders] ;
        NSLog(@"Fetched reminders - %@", self.reminders);
        [self.tableView reloadData];
    }];

}


#pragma mark -
#pragma mark Add a new reminder

// Display an event edit view controller when the user taps the "+" button.
// A new event is added to Calendar when the user taps the "Done" button in the above view controller.
- (IBAction)addEvent:(id)sender
{
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
          didCompleteWithAction:(EKEventEditViewAction)action
{
    // Dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:^
    {
        if (action != EKEventEditViewActionCanceled)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                // Re-fetch all events happening in the next 24 hours
                [self fetchRemindersFrom:self.currentReminderCalendar];
                // Update the UI with the above events
                [self.tableView reloadData];
            });
        }
    }];
}


// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller
{
    return self.currentReminderCalendar;
}


- (IBAction)showSettings:(id)sender {
    NSLog(@"Showing the settings");
    self.reminderSettingsVC.rm = self.rm;
    [self presentViewController:self.reminderSettingsVC
                       animated:YES
                     completion:nil];
}


@end
