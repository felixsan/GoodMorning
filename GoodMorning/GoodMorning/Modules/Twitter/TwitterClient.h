//
//  TwitterClient.h
//  GoodMorning
//
//  Created by Ben Lindsey on 10/31/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Foundation/Foundation.h>

@interface TwitterClient : NSObject

+ (TwitterClient *)instance;

- (void)requestAccess:(void (^)(BOOL granted, NSError *error))callback;

- (void)homeTimelineWithCount:(int)count sinceId:(NSString *)sinceId maxId:(NSString *)maxId callback:(void (^)(NSError *error, SLRequest *request, NSArray *response))callback;

@end
