//
//  StoreHistoryController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreHistoryController.h"

@interface StoreHistoryController () {
    NSArray *dates;
    NSMutableDictionary *storesToDate;
}

@end

@implementation StoreHistoryController

#pragma mark - Parent Methods –

- (void)awakeFromNib {
    [super awakeFromNib];
    storesToDate = [NSMutableDictionary new];
}

- (void)viewDidAppear:(BOOL)animated {
    [self initData];
    [self.tableView reloadData];
}

#pragma mark - Init Methods -

- (void)initData {
    NSOrderedSet *orderedDates = [NSOrderedSet orderedSetWithArray:[self.databaseManagerApp.selectCommands selectDatesInHistoryTable]];
    dates = [orderedDates array];
}

#pragma mark - Table Methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [storesToDate setObject:[self.databaseManagerApp.selectCommands selectOfflineStoresInHistoryTableWithDate:[dates objectAtIndex:section]]
                     forKey:[dates objectAtIndex:section]];
    return [[storesToDate objectForKey:[dates objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [dates objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Store" forIndexPath:indexPath];
    
    NSString *storeNum = [[[storesToDate objectForKey:[dates objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"storeNum"];
    NSString *city = [[[storesToDate objectForKey:[dates objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"city"];
    
    if ([city length] != 0) {
        cell.storeName.text = [NSString stringWithFormat:@"Store #%@", storeNum];
    } else {
        cell.storeName.text = [NSString stringWithFormat:@"Store #%@", storeNum];
        cell.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Navigation Methods -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Store Details"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        
        StoreDetailsController *storeDetailsController = [segue destinationViewController];
        storeDetailsController.storeNumber = [[[storesToDate objectForKey:[dates objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"storeNum"];
    }
}

@end
