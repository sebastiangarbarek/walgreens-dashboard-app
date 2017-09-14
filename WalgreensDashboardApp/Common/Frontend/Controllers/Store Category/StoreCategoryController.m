//
//  StoreCategoryController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 14/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreCategoryController.h"

@implementation StoreCategoryController

#pragma mark - Parent Methods –

- (void)awakeFromNib {
    [super awakeFromNib];
    self.storesToCategory = [NSMutableDictionary new];
}

- (void)viewDidAppear:(BOOL)animated {
    [self initData];
    [self.tableView reloadData];
}

#pragma mark - Init Methods -

- (void)initData {
    
}

#pragma mark - Table Methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Store" forIndexPath:indexPath];
    

    
    return cell;
}

#pragma mark - Navigation Methods -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Store Details"]) {
        
    }
}

@end
