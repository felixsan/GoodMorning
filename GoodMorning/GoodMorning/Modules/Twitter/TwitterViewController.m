//
//  TwitterCell.m
//  GoodMorning
//
//  Created by Ben Lindsey on 10/26/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "TwitterViewController.h"
#import "TwitterView.h"

@interface TwitterViewController ()

@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) ACAccountStore *accountStore;

- (void)fetchTimelineForUser;

@end

@implementation TwitterViewController

+ (NSUInteger)rows
{
    return 2;
}

+ (NSUInteger)cols
{
    return 1;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TwitterView *twitter = (TwitterView *)self.view;
    twitter.tableView.dataSource = self;
    
    [self fetchTimelineForUser];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *tweet = self.tweets[indexPath.row];
    NSURL *profile = [NSURL URLWithString:[tweet valueForKeyPath:@"user.profile_image_url"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:profile]];
    cell.imageView.image = image;
    cell.imageView.layer.cornerRadius = 5.0;
    cell.imageView.layer.masksToBounds = YES;
    cell.textLabel.text = [tweet objectForKey:@"text"];
    return cell;
}

#pragma mark - Private methods

- (void)fetchTimelineForUser
{
    // Step 0: Check for twitter account
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [self.accountStore requestAccessToAccountsWithType:twitterAccountType
                                                   options:NULL
                                                completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:twitterAccountType];
                 ACAccount *twitter = [twitterAccounts lastObject];
                 
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                               @"/1.1/statuses/home_timeline.json"];
                 SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                         requestMethod:SLRequestMethodGET
                                                                   URL:url
                                                            parameters:nil];
                 
                 //  Attach an account to the request
                 [request setAccount:twitter];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                      
                      if (responseData) {
                          if (urlResponse.statusCode >= 200 &&
                              urlResponse.statusCode < 300) {
                              
                              NSError *jsonError;
                              id timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                              if (timelineData) {
                                  NSLog(@"%@", timelineData);
                                  self.tweets = timelineData;
                                  [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                              } else {
                                  // Our JSON deserialization went awry
                                  NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                              }
                          } else {
                              // The server did not respond ... were we rate-limited?
                              NSLog(@"The response status code is %d",
                                    urlResponse.statusCode);
                          }
                      }
                  }];
             } else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
        }];
    }
}

- (void)reloadData
{
    TwitterView *twitter = (TwitterView *)self.view;
    [twitter.tableView reloadData];
}

@end
