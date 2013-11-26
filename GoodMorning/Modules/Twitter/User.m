//
//  User.m
//  Twittero
//
//  Created by Ben Lindsey on 10/18/13.
//
//

#import "User.h"

@implementation User

- (id)initWithDictionary:(NSDictionary *)data
{
    self = [self init];
    if (self) {
        _name = [data objectForKey:@"name"];
        _screenName = [data objectForKey:@"screen_name"];
        _profileImageURL = [data objectForKey:@"profile_image_url"];
        _statusesCount = [[data objectForKey:@"statuses_count"] integerValue];
        _followersCount = [[data objectForKey:@"followers_count"] integerValue];
        _friendsCount = [[data objectForKey:@"friends_count"] integerValue];
    }
    return self;
}

@end
