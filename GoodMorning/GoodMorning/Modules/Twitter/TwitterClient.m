//
//  TwitterClient.m
//  GoodMorning
//
//  Created by Ben Lindsey on 10/31/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

@interface TwitterClient ()

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic, readwrite) NSArray *accounts;

@end

@implementation TwitterClient

+ (TwitterClient *)instance
{
    static dispatch_once_t once;
    static TwitterClient *instance;

    dispatch_once(&once, ^{
        instance = [[TwitterClient alloc] init];
    });

    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return self;
}

- (void)requestAccess:(void (^)(BOOL, NSError *))callback
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

        [self.accountStore requestAccessToAccountsWithType:twitterAccountType
                                                   options:NULL
                                                completion:callback];
    } else {
        callback(NO, nil);
    }
}

- (NSArray *)accounts
{
    if (!_accounts) {
        ACAccountType *twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        _accounts = [self.accountStore accountsWithAccountType:twitterAccountType];
    }
    return _accounts;
}

- (ACAccount *)account
{
    if (!_account) {
        _account = [[self accounts] lastObject];
    }
    return _account;
}

- (void)homeTimelineWithCount:(int)count sinceId:(NSString *)sinceId maxId:(NSString *)maxId callback:(void (^)(NSError *, SLRequest *, NSArray *))callback
{
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(count) forKey:@"count"];
    if (sinceId) {
        [params setObject:sinceId forKey:@"since_id"];
    }
    if (maxId) {
        [params setObject:maxId forKey:@"max_id"];
    }
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];

    //  Attach an account to the request
    [request setAccount:self.account];

    //  Execute the request
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            if (urlResponse.statusCode >= 200 &&
                urlResponse.statusCode < 300) {

                NSError *jsonError;
                id timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                if ([timelineData isKindOfClass:[NSArray class]]) {
                    //NSLog(@"%@", timelineData);
                    callback(nil, request, [Tweet tweetsWithArray:timelineData]);
                } else {
                    // Our JSON deserialization went awry
                    callback(jsonError, request, nil);
                }
            } else {
                // The server did not respond ... were we rate-limited?
                NSLog(@"The response status code is %d",
                      urlResponse.statusCode);
                NSError *error = [NSError errorWithDomain:@"Invalid HTTP Response Code" code:urlResponse.statusCode userInfo:nil];
                callback(error, request, nil);
            }
        } else {
            callback(error, request, nil);
        }
    }];
}

@end
