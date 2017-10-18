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

- (BOOL)storeExists:(NSString *)storeNumber;

// Return IDs.
- (NSMutableArray *)selectOnlineStoreIdsInStoreTable;
- (NSMutableArray *)selectNonPrintStoreIdsInStoreTable;

// Return date string.
- (NSString *)selectPreviousUpdateDateInHistoryTableWithDate:(NSString *)date;
- (NSString *)selectNextUpdateDateInHistoryTableWithDate:(NSString *)date;

// Return count.
- (NSNumber *)countPrintStoresInStoreTable;

// Return rows.
- (NSMutableArray *)selectStoreDetailsWithStoreNumber:(NSString *)storeNumber;
- (NSDictionary *)selectCityStateForStore:(NSString *)storeNumber;
- (NSMutableArray *)selectStoreHoursWithStoreNumber:(NSString *)storeNumber;
- (NSMutableArray *)selectDatesInHistoryTable;
- (NSMutableArray *)selectOfflineStoresInHistoryTableWithDate:(NSString *)date;
- (NSArray *)selectStoresInState:(NSString *)state;
- (NSArray *)selectAllStoreCords;
- (NSArray *)selectAllPrintStoresAndHours;
- (NSArray *)selectAllProducts;

// Return states without duplicates
- (NSMutableArray *)selectStatesInStoreDetail;

// Return cities of one state
- (NSMutableArray *)selectCitiesInStoreDetailWithState:(NSString *)state;

// Return stores of one city
- (NSMutableArray *)selectStoresInStoreDetailWithCity:(NSString *)city;

// Boolean checks.
- (BOOL)storeHoursForStoreNumber:(NSString *)storeNumber;

// Offline history.
- (NSArray *)selectDistinctYearsInHistory;
- (NSArray *)selectDistinctMonthsForYear:(NSString *)year;

- (NSNumber *)countOfflineInHistoryTableWithDateTime:(NSString *)dateTime;

- (NSDictionary *)selectLastDowntime;
- (NSDictionary *)selectLastDowntimeToday;
- (NSDictionary *)selectStoreIfHasBeenOfflineToday:(NSString *)storeNumber;

@end
