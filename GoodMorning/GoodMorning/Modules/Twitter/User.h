//
//  User.h
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject

- (id)initWithDictionary:(NSDictionary *)data;

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *screenName;
@property (strong, nonatomic, readonly) NSString *profileImageURL;

@property (assign, nonatomic, readonly) NSInteger statusesCount;
@property (assign, nonatomic, readonly) NSInteger followersCount;
@property (assign, nonatomic, readonly) NSInteger friendsCount;

@end
