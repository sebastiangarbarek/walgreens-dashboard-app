//
//  OpenClosedCell.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 21/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "OpenClosedCell.h"

@interface OpenClosedCell () {
    NSMutableArray<DashboardCountCellData *> *cellCollection;
}

@end

@implementation OpenClosedCell

#pragma mark - Init Methods -

- (void)loadWithStores:(NSNumber *)open closed:(NSNumber *)closed {
    cellCollection = [NSMutableArray new];
    
    DashboardCountCellData *c1 = [DashboardCountCellData new];
    DashboardCountCellData *c2 = [DashboardCountCellData new];
    
    c1.backgroundColor = [UIColor printicularRed];
    c1.title = @"Stores Open";
    c1.count = [NSNumberFormatter localizedStringFromNumber:open numberStyle:NSNumberFormatterDecimalStyle];
    
    c2.backgroundColor = [UIColor printicularYellow];
    c2.title = @"Stores Closed";
    c2.count = [NSNumberFormatter localizedStringFromNumber:closed numberStyle:NSNumberFormatterDecimalStyle];
    
    [cellCollection addObject:c1];
    [cellCollection addObject:c2];
    
    [self.collectionView reloadData];
}

#pragma mark - Collection View Methods -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DashboardCountCell *dashboardCountCell;
    
    switch (indexPath.row) {
        case 0: {
            dashboardCountCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Open" forIndexPath:indexPath];
        }
        case 1: {
            dashboardCountCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Closed" forIndexPath:indexPath];
        }
        default:
            break;
    }
    
    dashboardCountCell.countLabel.adjustsFontSizeToFitWidth = YES;
    dashboardCountCell.descriptionLabel.adjustsFontSizeToFitWidth = YES;
    
    dashboardCountCell.backgroundColor = [cellCollection objectAtIndex:indexPath.row].backgroundColor;
    dashboardCountCell.descriptionLabel.text = [cellCollection objectAtIndex:indexPath.row].title;
    dashboardCountCell.countLabel.text = [cellCollection objectAtIndex:indexPath.row].count;
    
    return dashboardCountCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screen = [[UIScreen mainScreen] bounds];
    return CGSizeMake(screen.size.width / 2, screen.size.width / 2);
}

@end
