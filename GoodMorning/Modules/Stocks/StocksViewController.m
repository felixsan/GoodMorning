//
//  StocksViewController.m
//  GoodMorning
//
//  Created by Ben Lindsey on 11/10/13.
//  Copyright (c) 2013 MakeItRain. All rights reserved.
//

#import "StocksViewController.h"
#import "Stock.h"
#import "StockCell.h"
#import "StockClient.h"
#import "UIImageView+AFNetworking.h"

#define STOCKS_IDENTIFIER @"StockCell"

@interface StocksViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *periodControl;
@property (weak, nonatomic) IBOutlet UIImageView *chartImage;

@property (strong, nonatomic) NSMutableArray *stocks; // of Stock
@property (assign, nonatomic) NSInteger selectedRow;

@end

@implementation StocksViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:STOCKS_IDENTIFIER bundle:nil] forCellReuseIdentifier:STOCKS_IDENTIFIER];

    self.tableView.layer.borderColor = [self.tableView.separatorColor CGColor];
    self.tableView.layer.borderWidth = 1.f;
    self.tableView.layer.cornerRadius = 5.f;

    [StockClient stocksFromArray:@[@"^IXIC", @"^GSPC", @"AAPL", @"GOOG", @"FB"] callback:^(NSError *error, AFHTTPRequestOperation *operation, NSArray *response) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            [self.stocks addObjectsFromArray:response];
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.stocks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StockCell *cell = [tableView dequeueReusableCellWithIdentifier:STOCKS_IDENTIFIER forIndexPath:indexPath];
    cell.stock = self.stocks[indexPath.row];
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRow = indexPath.row;
    [self onSegmentChange];
}

#pragma mark - Private methods

- (NSMutableArray *)stocks
{
    if (!_stocks) {
        _stocks = [[NSMutableArray alloc] init];
    }
    return _stocks;
}

- (IBAction)onSegmentChange
{
    Stock *stock = self.stocks[self.selectedRow];
    NSString *period = [self.periodControl titleForSegmentAtIndex:self.periodControl.selectedSegmentIndex];
    NSString *symbol = [stock.symbol stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://chart.finance.yahoo.com/z?s=%@&t=%@", symbol, period];
    [self.chartImage setImageWithURL:[NSURL URLWithString:url]];
}

- (void)reloadData
{
    [self.tableView reloadData];
    [self onSegmentChange];
}

#pragma mark - Module methods

- (NSUInteger)rows
{
    return 2;
}

- (NSUInteger)cols
{
    return 1;
}

- (NSString *)headerTitle
{
    return @"Stocks";
}

- (UIColor *)headerColor
{
    return [UIColor colorWithRed:48.f/255 green:84.f/255 blue:144.f/255 alpha:1.f];
}

@end
