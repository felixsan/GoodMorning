//
//  Tweet.h
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

- (id)initWithDictionary:(NSDictionary *)data;

@property (strong, nonatomic, readonly) NSString *id;
@property (strong, nonatomic, readonly) NSString *text;

@property (strong, nonatomic, readonly) NSDate *createdAt;

@property (assign, nonatomic, readonly) NSInteger favoriteCount;
@property (assign, nonatomic, readonly) NSInteger retweetCount;

@property (strong, nonatomic, readonly) NSArray *userMentions; // of NSDictionary

@property (strong, nonatomic, readonly) User *user;

@property (assign, nonatomic) BOOL retweeted;
@property (assign, nonatomic) BOOL favorited;

@property (strong, nonatomic, readonly) Tweet *retweetedStatus;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
