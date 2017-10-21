//
//  OfflineHistoryCell.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "OfflineHistoryCell.h"

@implementation OfflineHistoryCell

- (void)loadCellDataWithOfflineStores:(NSArray *)offlineStoresForMonthInYear month:(NSNumber *)month year:(NSNumber *)year databaseManager:(DatabaseManager *)databaseManager {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
