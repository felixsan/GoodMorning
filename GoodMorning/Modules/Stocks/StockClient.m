//
//  StockClient.m
//  GoodMorning
//
//  Created by Ben Lindsey on 11/10/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "StockClient.h"
#import "Stock.h"

@implementation StockClient

+ (void)stocksFromArray:(NSArray *)symbols callback:(void (^)(NSError *, AFHTTPRequestOperation *, NSArray *))callback
{
    NSString *stocks = [[symbols componentsJoinedByString:@","] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://download.finance.yahoo.com/d/quotes.csv?s=%@&f=snl1c1ohgvrj1kja2y", stocks];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *data = [[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding];
        NSMutableArray *lines = [[data componentsSeparatedByString:@"\r\n"] mutableCopy];
        for (int i = 0; i < [lines count] - 1; ++i) {
            //NSLog(@"%@", lines[i]);
            NSArray *fields = [self componentsSeparatedByComma:lines[i]];
            Stock *stock = [[Stock alloc] init];
            stock.symbol = fields[0]; //s
            stock.name = fields[1]; //n
            stock.last = fields[2]; //l1
            stock.change = fields[3]; //c1
            stock.open = fields[4]; //o
            stock.high = fields[5]; //h
            stock.low = fields[6]; //g
            stock.volume = fields[7]; //v
            stock.PE = fields[8]; //r
            stock.marketCap = fields[9]; //j1
            stock.yearHigh = fields[10]; //k
            stock.yearLow = fields[11]; //j
            stock.averageVolume = fields[12]; //a2
            stock.yield = fields[13]; //y
            lines[i] = stock;
        }
        [lines removeLastObject]; // empty line
        callback(nil, operation, lines);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(error, operation, nil);
    }];
    [operation start];
}

+ (NSArray *)componentsSeparatedByComma:(NSString *)string
{
    BOOL insideQuote = NO;
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSMutableArray *tmp = [[NSMutableArray alloc] init];

    for (NSString *s in [string componentsSeparatedByString:@","]) {
        [tmp addObject:s];

        NSRange first = [s rangeOfString:@"\""];
        if (first.location == 0) {
            insideQuote = YES;
        }
        NSRange last = [s rangeOfString:@"\"" options:NSBackwardsSearch];
        if (last.location == [s length] - 1) {
            [results addObject:[tmp componentsJoinedByString:@","]];
            [tmp removeAllObjects];
            insideQuote = NO;
        } else if (!insideQuote && first.location == NSNotFound) {
            [results addObject:s];
            [tmp removeAllObjects];
        }
    }
    return results;
}

@end
