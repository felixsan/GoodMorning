//
//  Stock.m
//  GoodMorning
//
//  Created by Ben Lindsey on 11/10/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "Stock.h"

@implementation Stock

- (void)setName:(NSString *)name
{
    _name = [name substringWithRange:NSMakeRange(1, [name length] - 2)];
}

- (void)setSymbol:(NSString *)symbol
{
    _symbol = [symbol substringWithRange:NSMakeRange(1, [symbol length] - 2)];
}

@end
