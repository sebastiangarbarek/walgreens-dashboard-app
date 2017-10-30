//
//  SummaryCell.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 19/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "OfflineHistoryCell.h"

#import "UIColor+AppTheme.h"
#import "DashboardCountCell.h"
#import "DashboardCountCellData.h"
#import "OfflineStoresController.h"

@interface SummaryCell : OfflineHistoryCell <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
