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
    BOOL updated;
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
    [self configureViewOnAppearWithThemeColor:[UIColor printicularBlue]];
    
    if (!updated) {
        [self presentNotification:@"Checking Products" backgroundColor:[UIColor greenColor]];
        if ([reach isReachable]) {
            [self fetchProducts];
        } else {
            [self presentNotification:@"Waiting For Network" backgroundColor:[UIColor orangeColor]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init Methods -

- (void)loadProducts {
    products = [self.databaseManager.selectCommands selectAllProducts];
}

#pragma mark - View Methods -

- (void)presentNotification:(NSString *)notification backgroundColor:(UIColor *)color {
    self.notificationView.backgroundColor = color;
    self.notificationLabel.text = notification;
    self.notificationView.hidden = NO;
    // Display notification for 3 seconds.
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideNotification) userInfo:nil repeats:NO];
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
    
    NSString *productGroup = [products[indexPath.row] objectForKey:kProGroup];
    if ([productGroup isEqualToString:@"SQR01"]) {
        productCell.groupLabel.text = @"Square Print";
    } else if ([productGroup isEqualToString:@"STDPR"]) {
        productCell.groupLabel.text = @"Standard Print";
    } else {
        productCell.groupLabel.text = productGroup;
    }
    
    productCell.sizeLabel.text = [products[indexPath.row] objectForKey:kProSize];
    productCell.priceLabel.text = [NSString stringWithFormat:@"$%@ USD", [products[indexPath.row] objectForKey:kProPrice]];
    return productCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 132;
}

#pragma mark - Network Methods -

- (void)fetchProducts {
    // Build request.
    
    // Send request.
    
    // Update database.
    
    updated = YES;
}

#pragma mark - Action Methods -

- (IBAction)refreshProductList:(id)sender {
    
}

#pragma mark - Navigation Methods -
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
