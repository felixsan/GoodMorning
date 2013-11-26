//
//  StockCell.m
//  GoodMorning
//
//  Created by Ben Lindsey on 11/10/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "StockCell.h"

@interface StockCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *changeView;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;

@end

@implementation StockCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    self.backgroundColor = selected ? [UIColor colorWithRed:218.f/255 green:230.f/255 blue:242.f/255 alpha:1.f] : nil;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
}

- (void)setStock:(Stock *)stock
{
    _stock = stock;

    NSRange range = [stock.symbol rangeOfString:@"^"];
    self.nameLabel.text = range.location == NSNotFound ? stock.symbol : stock.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", [stock.last floatValue]];

    CALayer *layer = self.changeView.layer;
    layer.borderWidth = 1.f;
    layer.cornerRadius = 3.f;
    float change = [stock.change floatValue];
    if (change < 0) {
        self.changeLabel.text = [NSString stringWithFormat:@"%.2f", [stock.change floatValue]];
        layer.borderColor = [[UIColor colorWithRed:142.f/255 green:49.f/255 blue:39.f/255 alpha:1.f] CGColor];
        self.changeView.backgroundColor = [UIColor colorWithRed:149.f/255 green:47.f/255 blue:40.f/255 alpha:1.f];
    } else {
        self.changeLabel.text = [NSString stringWithFormat:@"+%.2f", [stock.change floatValue]];
        layer.borderColor = [[UIColor colorWithRed:111.f/255 green:147.f/255 blue:79.f/255 alpha:1.f] CGColor];
        self.changeView.backgroundColor = [UIColor colorWithRed:114.f/255 green:156.f/255 blue:64.f/255 alpha:1.f];
    }
}

@end
