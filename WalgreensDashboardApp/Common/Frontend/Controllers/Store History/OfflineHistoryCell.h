//
//  OfflineHistoryCell.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DatabaseManager.h"

@interface OfflineHistoryCell : UITableViewCell

- (void)loadCellDataWithOfflineStores:(NSArray *)offlineStoresForMonthInYear month:(NSNumber *)month year:(NSNumber *)year databaseManager:(DatabaseManager *)databaseManager;

@end
