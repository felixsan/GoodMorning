//
//  DraggableQuiltLayout.h
//  GoodMorning
//
//  Created by Ben Lindsey on 11/3/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "RFQuiltLayout.h"
#import "UICollectionViewLayout_Warpable.h"

@interface DraggableQuiltLayout : RFQuiltLayout <UICollectionViewLayout_Warpable>

@property (readonly, nonatomic) LSCollectionViewLayoutHelper *layoutHelper;

@end