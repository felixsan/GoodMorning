//
//  DevelopmentVC.m
//  GoodMorning
//
//  Created by Ben on 10/26/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "AVFoundation/AVSpeechSynthesis.h"
#import "DevelopmentVC.h"
#import "WeatherViewController.h"
#import "CountdownViewController.h"
#import "TwitterViewController.h"
#import "TrafficViewController.h"
#import "ReminderViewController.h"
#import "CalendarViewController.h"
#import "StocksViewController.h"
#import "SettingsViewController.h"

@interface DevelopmentVC ()

@property (strong, nonatomic) NSMutableArray *controllers;
@property (strong, nonatomic) UIViewController *settingsController;

- (void)onRead;
- (void)onEditButton;

- (void)moduleAdded:(NSNotification *)notification;
- (void)moduleRemoved:(NSNotification *)notification;

@end

@implementation DevelopmentVC

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.title = @"Good Morning";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *speakerImage = [UIImage imageNamed:@"Speaker"];
    UIBarButtonItem *speakerButton = [[UIBarButtonItem alloc] initWithImage:speakerImage
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(onRead)];
    [speakerButton setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = speakerButton;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEditButton)];

    WeatherViewController *weather = [[WeatherViewController alloc] init];
    TwitterViewController *twitter = [[TwitterViewController alloc] init];
    ReminderViewController *reminder = [[ReminderViewController alloc] init];
    CalendarViewController *calendar = [[CalendarViewController alloc] init];
    TrafficViewController *traffic = [[TrafficViewController alloc] init];
    CountdownViewController *countdown = [[CountdownViewController alloc] init];
    self.controllers = [[NSMutableArray alloc] initWithArray:@[ weather, twitter, reminder, calendar, traffic, countdown ]];

    for (UIViewController *controller in self.controllers) {
        [self addChildViewController:controller];
        [controller didMoveToParentViewController:self];
    }

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.draggable = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView reloadData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moduleRemoved:) name:ModuleRemovedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moduleAdded:) name:ModuleAddedNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.controllers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }

    ModuleController *controller = self.controllers[indexPath.row];
    
    if ([controller headerTitle]) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 328, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:18.f];
        label.text = [controller headerTitle];

        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 328, 30)];
        header.backgroundColor = [controller headerColor];
        [header addSubview:label];
        
        if ([controller settingsSelector]) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
            button.tintColor = [UIColor whiteColor];
            button.frame = CGRectMake(305, 8, 16, 16);
            [button addTarget:controller action:[controller settingsSelector] forControlEvents:UIControlEventTouchUpInside];
            [header addSubview:button];
        }

        if ([controller addSelector]) {
            UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
            addButton.tintColor = [UIColor whiteColor];
            addButton.frame = CGRectMake(20, 8, 16, 16);
            [addButton addTarget:controller action:[controller addSelector] forControlEvents:UIControlEventTouchUpInside];
            [header addSubview:addButton];
        }
        [cell addSubview:header];
        controller.view.frame = CGRectMake(0, 30, 328, [controller rows]*232 - 40);
    }
    [cell addSubview:controller.view];

    cell.layer.shadowOffset = CGSizeMake(2, 2);
    cell.layer.shadowColor = [[UIColor grayColor] CGColor];
    cell.layer.shadowRadius = 3.0f;
    cell.layer.shadowOpacity = 0.7f;

    return cell;
}

#pragma mark - UICollectionViewFlowLayout draggable

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    id object = [self.controllers objectAtIndex:fromIndexPath.row];
    [self.controllers removeObjectAtIndex:fromIndexPath.row];
    [self.controllers insertObject:object atIndex:toIndexPath.row];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - RFQuiltLayout delegate

- (CGSize)blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ModuleController *controller = self.controllers[indexPath.row];
    return CGSizeMake([controller cols], [controller rows]);
}

- (UIEdgeInsets)insetsForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - Private methods

- (UIViewController *)settingsController
{
    if (!_settingsController) {
        _settingsController = [[SettingsViewController alloc] init];
    }
    return _settingsController;
}

- (void)onEditButton
{
    [self presentViewController:self.settingsController animated:YES completion:nil];
}

- (void)moduleAdded:(NSNotification *)notification
{
    NSString *module = [NSString stringWithFormat:@"%@ViewController", notification.object];
    ModuleController *controller = [[NSClassFromString(module) alloc] init];
    [self.controllers addObject:controller];

    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.controllers count] - 1 inSection:0];
    [self.collectionView insertItemsAtIndexPaths:@[ indexPath ]];
}

- (void)moduleRemoved:(NSNotification *)notification
{
    NSString *module = [NSString stringWithFormat:@"%@ViewController", notification.object];
    NSInteger row;
    for (row = [self.controllers count] - 1; row >= 0; --row) {
        if ([[[self.controllers[row] class] description] isEqualToString:module]) {
            break;
        }
    }
    ModuleController *controller = self.controllers[row];
    [controller removeFromParentViewController];
    [self.controllers removeObjectAtIndex:row];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.collectionView deleteItemsAtIndexPaths:@[ indexPath ]];
}

- (void)onRead {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:[NSDate date]];
    NSInteger hour = [components hour];
    NSMutableString *timeOfDay = [@"" mutableCopy];
    if (hour >= 0 && hour < 12) {
        timeOfDay = [@"Morning" mutableCopy];
    } else if (hour >= 12 && hour < 18) {
        timeOfDay = [@"Afternoon" mutableCopy];
    } else {
        timeOfDay = [@"Evening" mutableCopy];
    }
    NSMutableString *scriptText = [[NSMutableString alloc] initWithFormat:@"Good %@. ", timeOfDay];
    for (ModuleController *controller in self.controllers) {
        [scriptText appendString: [controller moduleScript]];
    }


    AVSpeechUtterance *spokenScript = [[AVSpeechUtterance alloc] initWithString:scriptText];
    spokenScript.rate = 0.1666;
    spokenScript.pitchMultiplier = 1.3;
    AVSpeechSynthesizer *speech = [[AVSpeechSynthesizer alloc] init];
    [speech speakUtterance:spokenScript];
    NSLog(@"I'm gonna say - %@", scriptText);
}

@end
