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

- (BOOL)storeExists:(NSString *)storeNumber;
- (BOOL)storeHasLastBeenOfflineToday:(NSString *)storeNumber;

- (NSArray *)selectAllPrintStoreIds;
- (NSMutableArray *)selectNonPrintStoreIdsInStoreTable;
- (NSArray *)selectStoreDetailsWithStoreNumber:(NSString *)storeNumber;
- (NSArray *)selectStatesInStoreDetail;
- (NSDictionary *)selectCityStateForStore:(NSString *)storeNumber;
- (NSArray *)selectStoreHoursWithStoreNumber:(NSString *)storeNumber;
- (NSArray *)selectStoresInState:(NSString *)state;
- (NSArray *)selectAllStoreCords;
- (NSArray *)selectAllPrintStoresAndHours;
- (NSArray *)selectAllProducts;
- (NSArray *)selectDistinctYearsInHistory;
- (NSArray *)selectDistinctMonthsForYear:(NSNumber *)year;
- (NSArray *)selectOfflineStoresForMonth:(NSNumber *)month year:(NSNumber *)year;
- (NSDictionary *)selectStoreIfHasBeenOfflineToday:(NSString *)storeNumber;

- (NSNumber *)countPrintStoresInStoreTable;
- (NSInteger)countOfflineStoresForDay:(NSString *)day inMonth:(NSNumber *)month year:(NSNumber *)year;
- (NSNumber *)countOfflineInHistoryTableWithDateTime:(NSString *)dateTime;

@end
