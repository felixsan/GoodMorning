//
//  DevelopmentVC.m
//  GoodMorning
//
//  Created by Ben on 10/26/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "DevelopmentVC.h"
#import "WeatherViewController.h"
#import "CountdownViewController.h"
#import "TwitterViewController.h"
#import "TrafficViewController.h"
#import "ReminderViewController.h"
#import "CalendarViewController.h"
#import "LocationManager.h"

@interface DevelopmentVC ()

@property (strong, nonatomic) NSMutableArray *controllers;

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

    [[LocationManager instance] startUpdatingLocation];
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
        
        if ([controller respondsToSelector:@selector(settingsSelector)]) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
            button.tintColor = [UIColor whiteColor];
            button.frame = CGRectMake(305, 8, 16, 16);
            [button addTarget:controller action:[controller settingsSelector] forControlEvents:UIControlEventTouchUpInside];
            [header addSubview:button];
        }

        if ([controller respondsToSelector:@selector(addSelector)]) {
            UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
            addButton.tintColor = [UIColor whiteColor];
            addButton.frame = CGRectMake(20, 8, 16, 16);
            [addButton addTarget:controller action:[controller addSelector] forControlEvents:UIControlEventTouchUpInside];
            [header addSubview:addButton];
        }
        [cell addSubview:header];
        controller.view.frame = CGRectMake(0, 30, 328, 192);
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

@end
