//
//  SummaryCell.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 19/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "SummaryCell.h"

@interface SummaryCell () {
    NSMutableArray<DashboardCountCellData *> *cellCollection;
    NSArray *stores;
}

@end

@implementation SummaryCell

#pragma mark - Parent Methods -

- (void)loadCellDataWithOfflineStores:(NSArray *)offlineStoresForMonthInYear month:(NSNumber *)month year:(NSNumber *)year databaseManager:(DatabaseManager *)databaseManager {
    stores = offlineStoresForMonthInYear;
    
    NSNumber *offline = [self countStatus:@"C" inDataSet:offlineStoresForMonthInYear];
    NSNumber *scheduledMaintenance = [self countStatus:@"M" inDataSet:offlineStoresForMonthInYear];;
    NSNumber *unscheduledMaintenance = [self countStatus:@"T" inDataSet:offlineStoresForMonthInYear];;
    
    cellCollection = [NSMutableArray new];
    
    DashboardCountCellData *c1 = [DashboardCountCellData new];
    DashboardCountCellData *c2 = [DashboardCountCellData new];
    DashboardCountCellData *c3 = [DashboardCountCellData new];
    
    c1.backgroundColor = [UIColor printicularRed];
    c1.title = @"Offline";
    c1.count = [NSNumberFormatter localizedStringFromNumber:offline numberStyle:NSNumberFormatterDecimalStyle];
    
    c2.backgroundColor = [UIColor printicularYellow];
    c2.title = @"Scheduled Maintenance";
    c2.count = [NSNumberFormatter localizedStringFromNumber:scheduledMaintenance numberStyle:NSNumberFormatterDecimalStyle];
    
    c3.backgroundColor = [UIColor printicularYellow];
    c3.title = @"Unscheduled Maintenance";
    c3.count = [NSNumberFormatter localizedStringFromNumber:unscheduledMaintenance numberStyle:NSNumberFormatterDecimalStyle];
    
    [cellCollection addObject:c1];
    [cellCollection addObject:c2];
    [cellCollection addObject:c3];
    
    [self.collectionView reloadData];
}

#pragma mark - Collection View Methods -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DashboardCountCell *dashboardCountCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Count Cell" forIndexPath:indexPath];
    
    // Configure.
    dashboardCountCell.countLabel.adjustsFontSizeToFitWidth = YES;
    dashboardCountCell.descriptionLabel.adjustsFontSizeToFitWidth = YES;
    
    // Assign.
    dashboardCountCell.backgroundColor = [cellCollection objectAtIndex:indexPath.row].backgroundColor;
    dashboardCountCell.descriptionLabel.text = [cellCollection objectAtIndex:indexPath.row].title;
    dashboardCountCell.countLabel.text = [cellCollection objectAtIndex:indexPath.row].count;
    
    return dashboardCountCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screen = [[UIScreen mainScreen] bounds];
    return CGSizeMake(screen.size.width / 2, screen.size.width / 2);
}

#pragma mark - Navigation Methods -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UICollectionViewCell *senderCell = (UICollectionViewCell *)sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:senderCell];
    
    NSArray *offlineStores;
    
    switch (indexPath.row) {
        case 0:
            // Offline.
        {
            offlineStores = [self offlineStoresForStatus:@"C"];
        }
            break;
        case 1:
            // Maintenance.
        {
            offlineStores = [self offlineStoresForStatus:@"M"];
        }
            break;
        case 2:
            // Unscheduled Maintenance.
        {
            offlineStores = [self offlineStoresForStatus:@"T"];
        }
            break;
        default:
            break;
    }
    
    OfflineStoresController *destination = [segue destinationViewController];
    destination.offlineStores = offlineStores;
}

#pragma mark - Helper Methods -

- (NSNumber *)countStatus:(NSString *)status inDataSet:(NSArray *)dataSet {
    int count = 0;
    
    for (NSDictionary *offlineStore in dataSet) {
        if ([[offlineStore objectForKey:@"status"] isEqualToString:status]) {
            count++;
        }
    }
    
    return @(count);
}

- (NSArray *)offlineStoresForStatus:(NSString *)status {
    NSMutableArray *offlineStores = [NSMutableArray new];
    for (NSDictionary *offlineStore in stores) {
        if ([[offlineStore objectForKey:@"status"] isEqualToString:status]) {
            [offlineStores addObject:offlineStore];
        }
    }
    return offlineStores;
}

@end
