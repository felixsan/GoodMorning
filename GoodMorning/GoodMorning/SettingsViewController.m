//
//  SettingsViewController.m
//  GoodMorning
//
//  Created by Ben Lindsey on 11/9/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "SettingsViewController.h"

NSString * const ModuleAddedNotification = @"ModuleAddedNotification";
NSString * const ModuleRemovedNotification = @"ModuleRemovedNotification";

#define SETTINGS_REUSE_IDENTIFIER @"SettingsCell"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *modules; // of NSString

@end

@implementation SettingsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    self.modules = @[ @"Weather", @"Twitter", @"Reminder", @"Calendar", @"Traffic", @"Countdown", @"Stocks" ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:SETTINGS_REUSE_IDENTIFIER];
}

- (void)viewWillLayoutSubviews
{
    self.view.superview.bounds = CGRectMake(0, 0, 540, 60 + ([self.modules count] + 1)/2*60);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.modules count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SETTINGS_REUSE_IDENTIFIER forIndexPath:indexPath];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 27, 16, 16)];
    [button setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
    button.userInteractionEnabled = NO;
    button.selected = ![self.modules[indexPath.row] isEqualToString:@"Stocks"]; // HACK: stocks is initially not shown
    button.tag = 1;
    [cell.contentView addSubview:button];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 25, 200, 20)];
    label.text = self.modules[indexPath.row];
    [cell.contentView addSubview:label];

    return cell;
}

#pragma mark - UICollectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIButton *button = (UIButton *)[cell viewWithTag:1];
    NSString *notification = button.selected ? ModuleRemovedNotification : ModuleAddedNotification;
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self.modules[indexPath.row]];
    button.selected = !button.selected;
}

#pragma mark - Private methods

- (IBAction)onDoneButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
