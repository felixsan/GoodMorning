//
//  StockClient.h
//  GoodMorning
//
//  Created by Ben Lindsey on 11/10/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface StockClient : NSObject

+ (void)stocksFromArray:(NSArray *)symbols callback:(void (^)(NSError *error, AFHTTPRequestOperation *operation, NSArray *response))callback;

@end
