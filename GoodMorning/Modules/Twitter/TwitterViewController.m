//
//  TwitterCell.m
//  GoodMorning
//
//  Created by Ben Lindsey on 10/26/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#include <Foundation/NSString.h>
#import "TwitterViewController.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "TwitterSettingsVC.h"

#define REUSE_IDENTIFIER @"TweetCell"

@interface TwitterViewController ()

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *tweets;
@property (assign, nonatomic) BOOL loading;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) TwitterSettingsVC *settingsController;

- (void)handleRefresh;

@end

@implementation TwitterViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRefresh) name:TwitterAccountChangedNotification object:nil];
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 328, 424)];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        [self handleRefresh];
    } else {
        CGRect frame = CGRectMake(10, 25, 308, 100);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.numberOfLines = 0;
        label.text = @"No Twitter accounts have been added to this iPad";
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

- (NSMutableArray *)tweets
{
    if (!_tweets) {
        _tweets = [[NSMutableArray alloc] init];;
    }
    return _tweets;
}

- (TwitterSettingsVC *)settingsController
{
    if (!_settingsController) {
        _settingsController = [[TwitterSettingsVC alloc] init];
    }
    return _settingsController;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = self.tweets[indexPath.row];
    NSString *text = tweet.text;
    NSUInteger offset = 30;
    if (tweet.retweetedStatus) {
        text = tweet.retweetedStatus.text;
        offset = 48;
    }

    CGFloat width = self.view.frame.size.width - 81;
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:13] };
    CGRect frame = [text boundingRectWithSize:CGSizeMake(width, 1000)
                                      options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes:attributes
                                      context:nil];
    return MAX(68.0, frame.size.height + offset);
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height - 500;
    if (actualPosition >= contentHeight && !self.loading) {
        Tweet *tweet = [self.tweets lastObject];
        self.loading = YES;
        [[TwitterClient instance] homeTimelineWithCount:21 sinceId:0 maxId:tweet.id callback:^(NSError *error, SLRequest *request, NSArray *response) {
            if (error) {
            } else {
                [self.tweets removeObjectAtIndex:[self.tweets count] - 1];
                [self.tweets addObjectsFromArray:response];
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
            self.loading = NO;
        }];
    }
}

#pragma mark - Private methods

- (void)handleRefresh
{
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 328, 424)];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorInset = UIEdgeInsetsZero;

        [self.tableView registerNib:[UINib nibWithNibName:REUSE_IDENTIFIER bundle:nil] forCellReuseIdentifier:REUSE_IDENTIFIER];

        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
        [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
        [self.tableView addSubview:self.refreshControl];

        [self.view addSubview:self.tableView];
    }
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 callback:^(NSError *error, SLRequest *request, NSArray *response) {
        if (error) {
        } else {
            [self.tweets removeAllObjects];
            [self.tweets addObjectsFromArray:response];
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - module controller

- (NSUInteger)rows
{
    return 2;
}

- (NSUInteger)cols
{
    return 1;
}

- (NSString *)headerTitle
{
    return @"Twitter";
}

- (UIColor *)headerColor
{
    return [UIColor colorWithRed:85.0/255 green:172.0/255 blue:238.0/255 alpha:1.0];
}

- (SEL)settingsSelector
{
    return @selector(showSettings);
}

- (void)showSettings
{
    [self presentViewController:self.settingsController
                       animated:YES
                     completion:nil];
}

- (void)requestAccess
{
    [[TwitterClient instance] requestAccess:^(BOOL granted, NSError *error) {
        if (granted) {
            [self handleRefresh];
        }
    }];
}

@end
