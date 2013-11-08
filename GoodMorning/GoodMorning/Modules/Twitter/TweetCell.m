//
//  TweetCell.m
//  GoodMorning
//
//  Created by Ben Lindsey on 10/30/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "TweetCell.h"
#import "AFNetworking.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;

@end

@implementation TweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTweet:(Tweet *)tweet
{
    _tweet = tweet;
    User *user = tweet.user;

    float inset = 20.f;
    if (tweet.retweetedStatus) {
        self.retweetLabel.text = [NSString stringWithFormat:@"%@ retweeted", user.name];
        user = tweet.retweetedStatus.user;
        inset = 0.f;
    }
    CGRect bounds = self.contentView.bounds;
    self.contentView.bounds = CGRectMake(0, inset, bounds.size.width, bounds.size.height);

    // profile pic
    NSURL *url = [NSURL URLWithString:user.profileImageURL];
    [self.profileImage setImageWithURL:url];
    self.profileImage.layer.cornerRadius = 5.0;
    self.profileImage.layer.masksToBounds = YES;

    self.nameLabel.text = user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];

    NSTimeInterval interval = -1 * [tweet.createdAt timeIntervalSinceNow];
    if (interval > 86400) {
        self.timeLabel.text = [NSString stringWithFormat:@"%0.fd", interval/86400];
    } else if (interval > 3600) {
        self.timeLabel.text = [NSString stringWithFormat:@"%0.fh", interval/3600];
    } else if (interval > 60) {
        self.timeLabel.text = [NSString stringWithFormat:@"%0.fm", interval/60];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"%0.fs", interval];
    }

    self.tweetLabel.text = tweet.retweetedStatus ? tweet.retweetedStatus.text : tweet.text;
}

@end
