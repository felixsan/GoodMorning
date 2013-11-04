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

@interface CalendarSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    // Do any additional setup after loading the view from its nib.

    // Add in our custom cell
    UINib *calendarListCellNib = [UINib nibWithNibName:@"CalendarListCell" bundle:nil];
    [self.tableView registerNib:calendarListCellNib forCellReuseIdentifier:@"calendarCell"];

    // Set the table inset
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 40, 0, 10);


}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0,0,722, 413);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.availableCalendars count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the event at the row selected and display its title
    EKCalendar *calendar= [self.availableCalendars objectAtIndex:(NSUInteger) indexPath.row];

    CalendarListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"calendarCell" forIndexPath:indexPath];
    cell.calendar = calendar;

    return cell;
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (IBAction)saveChanges:(id)sender {
//    self.displayedCalendars
//    [[NSUserDefaults standardUserDefaults] setObject:@{} forKey:@"calendarKey"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES  completion:nil];

}

@end
