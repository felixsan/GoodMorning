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

#define REUSE_IDENTIFIER @"TweetCell"

@interface TwitterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *tweets;
@property (assign, nonatomic) BOOL loading;

- (void)fetchTimelineForUser;

@end

@implementation TwitterViewController

- (NSUInteger)rows
{
    return 2;
}

- (NSUInteger)cols
{
    return 1;
}

- (NSMutableArray *)tweets
{
    if (!_tweets) {
        _tweets = [[NSMutableArray alloc] init];;
    }
    return _tweets;
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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    UINib *nib = [UINib nibWithNibName:REUSE_IDENTIFIER bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:REUSE_IDENTIFIER];
    
    [self fetchTimelineForUser];
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
    CGFloat width = self.view.frame.size.width - 81;
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14] };
    CGRect frame = [tweet.text boundingRectWithSize:CGSizeMake(width, 1000)
                                            options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                         attributes:attributes
                                            context:nil];
    return MAX(68.0, frame.size.height + 30);
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height - 500;
    if (actualPosition >= contentHeight && !self.loading) {
        Tweet *tweet = [self.tweets lastObject];
        self.loading = YES;
        [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:tweet.id callback:^(NSError *error, SLRequest *request, NSArray *response) {
            if (error) {
            } else {
                [self.tweets addObjectsFromArray:response];
                [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
                   [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
               }
               self.loading = NO;
           }];
        } else {
            // TODO: render a special view
        }
    }];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

@end
