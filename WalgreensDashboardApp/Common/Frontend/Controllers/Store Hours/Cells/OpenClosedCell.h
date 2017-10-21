//
//  OpenClosedCell.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 21/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DashboardCountCell.h"
#import "DashboardCountCellData.h"
#import "UIColor+AppTheme.h"

@interface OpenClosedCell : UITableViewCell <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)loadWithOpen:(NSNumber *)open closed:(NSNumber *)closed;

@end
