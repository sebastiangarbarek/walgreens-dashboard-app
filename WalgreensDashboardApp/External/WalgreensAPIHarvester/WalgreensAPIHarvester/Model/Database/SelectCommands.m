//
//  DBSelectManager.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 27/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "SelectCommands.h"
#import "DatabaseManager.h"

@implementation SelectCommands

/*! Selects IDs of stores that were inserted as online in the store table.
 This method can be used to check the difference of stores in the database to stores on the server.
 It helps retrieve new stores or store details that were unable to be retrieved previously.
 *
 * \returns An array of IDs of stores that are confirmed.
 */
- (NSMutableArray *)selectOnlineStoreIdsInStoreTable {
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum FROM %@ WHERE status = 1", StoreTableName];
    NSMutableArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"storeNum"];
    return [self stringArrayWithArray:results];
}

/*! Selects all store IDs for the current day in the temp status table.
 This method is used to check if all stores for the current day have been checked.
 *
 * \returns An array of IDs of stores that have been checked.
 */
- (NSMutableArray *)selectStoreIdsInTempTable {
    [self.databaseManager.updateCommands deletePastTempStatuses];
    
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum FROM %@ WHERE date = '%@'", TempStatusTableName, [DateHelper currentDate]];
    NSMutableArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"storeNum"];
    return [self stringArrayWithArray:results];
}

/*! Selects all non-print store IDs in the store table.
 This method is used to remove non-print stores from status comparison.
 *
 * \returns An array of IDs of non-print stores.
 */
- (NSMutableArray *)selectNonPrintStoreIdsInStoreTable {
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum FROM %@ WHERE photoInd = 'false'", StoreTableName];
    NSMutableArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"storeNum"];
    return [self stringArrayWithArray:results];
}

/*! Selects the previous inserted date to given date in the history table.
 *
 * \returns Date in string format or nil if no date before given date.
 */
- (NSString *)selectPreviousUpdateDateInHistoryTableWithDate:(NSString *)date {
    NSString *commandString = [NSString stringWithFormat:@"SELECT date FROM %@ WHERE date < '%@' ORDER BY date DESC LIMIT 1", HistoryTableName, date];
    NSMutableArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"date"];
    if ([results count])
        return results[0];
    else
        return nil;
}

/*! Selects the next inserted date to given date in the history table.
 *
 * \returns Date in string format or nil if no date after given date.
 */
- (NSString *)selectNextUpdateDateInHistoryTableWithDate:(NSString *)date {
    NSString *commandString = [NSString stringWithFormat:@"SELECT date FROM %@ WHERE date > '%@' LIMIT 1", HistoryTableName, date];
    NSMutableArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"date"];
    if ([results count])
        return results[0];
    else
        return nil;
}

- (NSNumber *)countOfflineInHistoryTableWithDate:(NSString *)date {
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE date = '%@'", HistoryTableName, date];
    NSArray* results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"COUNT(*)"];
    if ([results count])
        return (NSNumber *) results[0];
    else
        return nil;
}

/*! Selects the count of print stores in store table.
 This method is used to subtract the difference from the offline history table to get online stores for a given day.
 *
 * \returns Date in string format or nil if no date before given date.
 */
- (NSNumber *)countPrintStoresInStoreTable {
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE photoInd = 'true'", StoreTableName];
    NSArray* results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"COUNT(*)"];
    if ([results count])
        return (NSNumber *) results[0];
    else
        return nil;
}

- (NSNumber *)countStoresInTempTable {
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE date = '%@'", TempStatusTableName, [DateHelper currentDate]];
    NSArray* results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"COUNT(*)"];
    if ([results count])
        return (NSNumber *) results[0];
    else
        return nil;
}

- (NSNumber *)countOnlineStoresInTempTable {
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE date = '%@' AND status = 1", TempStatusTableName, [DateHelper currentDate]];
    NSArray* results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"COUNT(*)"];
    if ([results count])
        return (NSNumber *) results[0];
    else
        return nil;
}

- (NSMutableArray *)selectOfflineStoresInHistoryTableWithDate:(NSString *)date {
    NSString *commandString = [NSString stringWithFormat:@"SELECT * FROM %@ INNER JOIN %@ ON %@.storeNum = %@.storeNum WHERE %@.date = '%@'", StoreTableName, HistoryTableName, HistoryTableName, StoreTableName, HistoryTableName, date];
    return [self.databaseManager executeQuery:[commandString UTF8String]];
}

- (NSMutableArray *)arrayWithResults:(NSMutableArray *)results key:(NSString *)key {
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (int i = 0; i < [results count]; i++) {
        [mutableArray addObject:[results[i] objectForKey:key]];
    }
    return mutableArray;
}

- (NSMutableArray *)stringArrayWithArray:(NSMutableArray *)array {
    NSMutableArray *stringArray = [NSMutableArray new];
    for (int i = 0; i < [array count]; i++) {
        [stringArray addObject:[array[i] stringValue]];
    }
    return stringArray;
}

@end
