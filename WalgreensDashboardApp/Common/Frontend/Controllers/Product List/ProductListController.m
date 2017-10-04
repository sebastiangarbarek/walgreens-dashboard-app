//
//  ProductListController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 5/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "ProductListController.h"

@interface ProductListController () {
    NSArray *products;
    Reachability *reach;
}

@end

@implementation ProductListController

#pragma mark - Parent Methods -

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadProducts];
    reach = [Reachability reachabilityForInternetConnection];
}

- (void)viewDidAppear:(BOOL)animated {
    [self presentNotification:@"Checking Products" backgroundColor:[UIColor greenColor]];
    if ([reach isReachable]) {
        [self fetchProducts];
    } else {
        [self presentNotification:@"Waiting For Network" backgroundColor:[UIColor orangeColor]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init Methods -

- (void)loadProducts {
    products = [self.databaseManagerApp.selectCommands selectAllProducts];
}

#pragma mark - View Methods -

- (void)presentNotification:(NSString *)notification backgroundColor:(UIColor *)color {
    self.notificationView.backgroundColor = color;
    self.notificationLabel.text = notification;
    self.notificationView.hidden = NO;
    // Display notification for 2 seconds.
    [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(hideNotification) userInfo:nil repeats:NO];
}

- (void)hideNotification {
    self.notificationView.hidden = YES;
}

#pragma mark - Table Methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductCell *productCell = [tableView dequeueReusableCellWithIdentifier:@"Product"];
    productCell.idLabel.text = [products[indexPath.row] objectForKey:kProId];
    productCell.groupLabel.text = [products[indexPath.row] objectForKey:kProGroup];
    productCell.sizeLabel.text = [products[indexPath.row] objectForKey:kProSize];
    productCell.priceLabel.text = [NSString stringWithFormat:@"$%@ USD", [products[indexPath.row] objectForKey:kProPrice]];
    return productCell;
}

#pragma mark - Network Methods -

- (void)fetchProducts {
    // Build request.
    
    // Send request.
    
    // Update database.
    
}

#pragma mark - Action Methods -

- (IBAction)refreshProductList:(id)sender {
    
}

#pragma mark - Navigation Methods -
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
