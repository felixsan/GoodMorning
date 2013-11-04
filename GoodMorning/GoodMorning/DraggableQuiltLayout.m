//
//  DraggableQuiltLayout.m
//  GoodMorning
//
//  Created by Ben Lindsey on 11/3/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "DraggableQuiltLayout.h"
#import "LSCollectionViewLayoutHelper.h"

@interface DraggableQuiltLayout ()
{
    LSCollectionViewLayoutHelper *_layoutHelper;
}
@end

@implementation DraggableQuiltLayout

- (LSCollectionViewLayoutHelper *)layoutHelper
{
    if(_layoutHelper == nil) {
        _layoutHelper = [[LSCollectionViewLayoutHelper alloc] initWithCollectionViewLayout:self];
    }
    return _layoutHelper;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.layoutHelper modifiedLayoutAttributesForElements:[super layoutAttributesForElementsInRect:rect]];
}

@end