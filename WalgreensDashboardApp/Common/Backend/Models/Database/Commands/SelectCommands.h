//
//  DBSelectManager.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 27/07/17.
//  Copyright � 2017 Sebastian Garbarek. All rights reserved.
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
- (NSMutableArray *)selectStoreDetailsWithStoreNumber:(NSString *)storeNumber;
- (NSMutableArray *)selectDatesInHistoryTable;
- (NSMutableArray *)selectOfflineStoresInHistoryTableWithDate:(NSString *)date;

// Return states without duplicates
- (NSMutableArray *)selectStatesInStoreDetail;

// Return cities of one state
- (NSMutableArray *)selectCitiesInStoreDetailWithState:(NSString *)state;

// Return stores of one city
- (NSMutableArray *)selectStoresInStoreDetailWithCity:(NSString *)city;

// Boolean checks.
- (BOOL)storeHoursForStoreNumber:(NSString *)storeNumber;

@end
