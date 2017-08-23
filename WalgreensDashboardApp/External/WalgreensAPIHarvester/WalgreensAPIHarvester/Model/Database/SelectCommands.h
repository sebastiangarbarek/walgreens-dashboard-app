//
//  DBSelectManager.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 27/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "Commands.h"
#import "DateHelper.h"

@interface SelectCommands : Commands

// Return IDs.
- (NSMutableArray *)selectOnlineStoreIdsInStoreTable;
- (NSMutableArray *)selectStoreIdsInTempTable;
- (NSMutableArray *)selectNonPrintStoreIdsInStoreTable;

// Return date string.
- (NSString *)selectPreviousUpdateDateInHistoryTableWithDate:(NSString *)date;
- (NSString *)selectNextUpdateDateInHistoryTableWithDate:(NSString *)date;

// Return count.
- (NSNumber *)countOfflineInHistoryTableWithDate:(NSString *)date;
- (NSNumber *)countPrintStoresInStoreTable;
- (NSNumber *)countStoresInTempTable;
- (NSNumber *)countOnlineStoresInTempTable;

// Return rows.
- (NSMutableArray *)selectOfflineStoresInHistoryTableWithDate:(NSString *)date;

@end
