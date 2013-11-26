//
//  ModuleHeaderView.m
//  GoodMorning
//
//  Created by Felix Santiago on 10/31/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "ModuleHeaderView.h"

@interface ModuleHeaderView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;

-(void) setup;

@end


@implementation ModuleHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setTitle:(NSString *)title {
    _title =title;
    self.contentTitle.text = _title;
}

- (void)setup {
//    [[NSBundle mainBundle] loadNibNamed:@"ModuleHeaderView" owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

@end
