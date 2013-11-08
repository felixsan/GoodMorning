//
//  TwitterCell.m
//  GoodMorning
//
//  Created by Ben Lindsey on 10/26/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "TwitterViewController.h"
#import "TweetCell.h"
#import "TwitterClient.h"
#import "TwitterSettingsVC.h"

#define REUSE_IDENTIFIER @"TweetCell"

@interface TwitterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *tweets;
@property (assign, nonatomic) BOOL loading;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) TwitterSettingsVC *settingsController;

- (void)fetchTimelineForUser;
- (void)handleRefresh;

@end

@implementation TwitterViewController

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

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    UINib *nib = [UINib nibWithNibName:REUSE_IDENTIFIER bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:REUSE_IDENTIFIER];

    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];

    [self fetchTimelineForUser];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRefresh) name:TwitterAccountChangedNotification object:nil];
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

- (UIRefreshControl *)refreshControl
{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
    }
    return _refreshControl;
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

- (void)fetchTimelineForUser
{
    [[TwitterClient instance] requestAccess:^(BOOL granted, NSError *error) {
        if (granted) {
            self.loading = YES;
            [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 callback:^(NSError *error, SLRequest *request, NSArray *response) {
               if (error) {
               } else {
                   [self.tweets addObjectsFromArray:response];
                   [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
               }
               self.loading = NO;
           }];
        } else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            CGRect frame = CGRectMake(10, 10, 328, 24);
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label.text = @"Sorry, no twitter accounts found";
            [self.view addSubview:label];
        }
    }];
}

- (void)handleRefresh
{
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

@end
