//
//  CreditsView.m
//  GoodMorning
//
//  Created by Ben on 11/30/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "CreditsView.h"

@implementation CreditsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [self loadNib];
    
    return self;
}

- (void)loadNib {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *views = [mainBundle loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:views[0]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)openApiUrl:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://forecast.io/"]];
}

- (IBAction)openIconsUrl:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://adamwhitcroft.com/climacons/"]];
}
@end
