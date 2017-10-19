//
//  DBSelectManager.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 27/07/17.
//  Copyright � 2017 Sebastian Garbarek. All rights reserved.
//

#import "SelectCommands.h"
#import "DatabaseManager.h"

@implementation SelectCommands

- (BOOL)storeExists:(NSString *)storeNumber {
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum FROM %@ WHERE storeNum = %@", StoreTableName, storeNumber];
    NSArray *results = [self.databaseManager executeQuery:[commandString UTF8String]];
    if ([results count]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)storeHasLastBeenOfflineToday:(NSString *)storeNumber {
    NSString *currentDate = [DateHelper currentDate];
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum FROM offline_history WHERE storeNum = '%@' AND offlineDateTime LIKE '%@%%' AND onlineDateTime IS NULL ORDER BY offlineDateTime DESC LIMIT 1", storeNumber, currentDate];
    NSArray *results = [self.databaseManager executeQuery:[commandString UTF8String]];
    if ([results count]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray *)selectAllPrintStoreIds {
    NSString *commandString = @"SELECT storeNum FROM store_detail WHERE photoInd = 'true'";
    return [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"storeNum"];
}

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
    NSString *commandString = [NSString stringWithFormat:@"SELECT offlineDateTime FROM %@ WHERE offlineDateTime < '%@' ORDER BY offlineDateTime DESC LIMIT 1", HistoryTableName, date];
    NSMutableArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"offlineDateTime"];
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
    NSString *commandString = [NSString stringWithFormat:@"SELECT offlineDateTime FROM %@ WHERE offlineDateTime > '%@' LIMIT 1", HistoryTableName, date];
    NSMutableArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"offlineDateTime"];
    if ([results count])
        return results[0];
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

- (NSMutableArray *)selectStoreDetailsWithStoreNumber:(NSString *)storeNumber {
    NSString *commandString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE storeNum = %@", StoreTableName, storeNumber];
    return [self.databaseManager executeQuery:[commandString UTF8String]];
}

- (NSDictionary *)selectCityStateForStore:(NSString *)storeNumber {
    NSString *commandString = [NSString stringWithFormat:@"SELECT city, state FROM %@ WHERE storeNum = %@", StoreTableName, storeNumber];
    NSArray *result = [self.databaseManager executeQuery:[commandString UTF8String]];
    if ([result count])
        return result[0];
    else
        return nil;
}

- (NSMutableArray *)selectStoreHoursWithStoreNumber:(NSString *)storeNumber {
    NSString *commandString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE storeNum = %@", StoreHourTableName, storeNumber];
    return [self.databaseManager executeQuery:[commandString UTF8String]];
}

- (BOOL)storeHoursForStoreNumber:(NSString *)storeNumber {
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE storeNum = %@", StoreHourTableName, storeNumber];
    NSArray* results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"COUNT(*)"];
    if ([results count])
        return YES;
    else
        return NO;
}

- (NSMutableArray *)selectDatesInHistoryTable {
    NSString *commandString = [NSString stringWithFormat:@"SELECT offlineDateTime FROM %@", HistoryTableName];
    return [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"offlineDateTime"];
}

- (NSMutableArray *)selectOfflineStoresInHistoryTableWithDate:(NSString *)date {
    NSString *commandString = [NSString stringWithFormat:@"SELECT * FROM %@ INNER JOIN %@ ON %@.storeNum = %@.storeNum WHERE %@.offlineDateTime = '%@'", StoreTableName, HistoryTableName, HistoryTableName, StoreTableName, HistoryTableName, date];
    return [self.databaseManager executeQuery:[commandString UTF8String]];
}

- (NSArray *)selectStoresInState:(NSString *)state {
    // Select only print stores.
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum, street, city FROM %@ WHERE state = '%@' AND photoInd = 'true'", StoreTableName, state];
    return [self.databaseManager executeQuery:[commandString UTF8String]];
}

- (NSArray *)selectAllStoreCords {
    // Ignores null. Select only print stores.
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum, street, latitude, longitude FROM %@ WHERE photoInd = 'true' AND latitude IS NOT NULL", StoreTableName];
    return [self.databaseManager executeQuery:[commandString UTF8String]];
}

- (NSArray *)selectAllPrintStoresAndHours {
    NSString *commandString = [NSString stringWithFormat:@"SELECT store_hour.storeNum, store_detail.twentyFourHr, store_detail.street, store_detail.state, store_detail.city, store_detail.latitude, store_detail.longitude, store_detail.timezone, store_hour.monOpen, store_hour.monClose, store_hour.tueOpen, store_hour.tueClose, store_hour.wedOpen, store_hour.wedClose, store_hour.thuOpen, store_hour.thuClose, store_hour.friOpen, store_hour.friClose, store_hour.satOpen, store_hour.satClose, store_hour.sunOpen, store_hour.sunClose FROM store_detail INNER JOIN store_hour ON store_hour.storeNum = store_detail.storeNum WHERE photoInd = 'true' AND monOpen IS NOT NULL"];
    return [self.databaseManager executeQuery:[commandString UTF8String]];
}

- (NSArray *)selectAllProducts {
    NSString *commandString = @"SELECT * FROM product_detail";
    return [self.databaseManager executeQuery:[commandString UTF8String]];
}

#pragma mark - Offline History -

- (NSArray *)selectDistinctYearsInHistory {
    NSString *commandString = @"SELECT DISTINCT year FROM offline_history ORDER BY offlineDateTime DESC";
    
    NSArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"year"];
    
    return results;
}

- (NSArray *)selectDistinctMonthsForYear:(NSNumber *)year {
    // Returns in descending order i.e. most recent month is first in array.
    NSString *commandString = [NSString stringWithFormat:@"SELECT DISTINCT month FROM offline_history WHERE year = %@ ORDER BY offlineDateTime DESC", year];
    
    NSArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"month"];
    
    return results;
}

- (NSArray *)selectOfflineStoresForMonth:(NSNumber *)month year:(NSNumber *)year {
    // Returns in ascending order i.e. oldest record is first in array.
    NSString *commandString = [NSString stringWithFormat:@"SELECT offline_history.storeNum, offline_history.offlineDateTime, offline_history.onlineDateTime, offline_history.status, store_detail.street, store_detail.city, store_detail.state, store_detail.longitude, store_detail.latitude FROM offline_history INNER JOIN store_detail ON store_detail.storeNum = offline_history.storeNum WHERE offline_history.month = %@ AND offline_history.year = %@ ORDER BY offline_history.offlineDateTime ASC", month, year];
    return [self.databaseManager executeQuery:[commandString UTF8String]];
}

- (NSInteger)countOfflineStoresForDay:(NSString *)day inMonth:(NSNumber *)month year:(NSNumber *)year {
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(DISTINCT storeNum) FROM offline_history WHERE day = %@ AND month = %@ AND year = %@", day, month, year];
    NSArray *results = [self.databaseManager executeQuery:[commandString UTF8String]];
    if ([results count]) {
        return [[results[0] objectForKey:@"COUNT(DISTINCT storeNum)"] integerValue];
    } else {
        return 0;
    }
}

// Used for dashboard screen.
- (NSNumber *)countOfflineInHistoryTableWithDateTime:(NSString *)dateTime {
    // Seperate date and time.
    NSArray *dateTimeSeperated = [dateTime componentsSeparatedByString:@" "];
    
    // Count the unique number of stores that were offline at anytime today, that haven't be resolved as online and do not include server downtime.
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(DISTINCT storeNum) FROM %@ WHERE offlineDateTime LIKE '%@%%' AND storeNum != 'All' AND onlineDateTime IS NULL", HistoryTableName, dateTimeSeperated[0]];
    NSArray* results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"COUNT(DISTINCT storeNum)"];
    if ([results count])
        return (NSNumber *) results[0];
    else
        return nil;
}

- (NSDictionary *)selectLastDowntime {
    NSString *commandString = @"SELECT * FROM offline_history WHERE storeNum = 'All' ORDER BY offlineDateTime DESC LIMIT 1";
    NSArray *results = [self.databaseManager executeQuery:[commandString UTF8String]];
    if ([results count]) {
        return results[0];
    } else {
        return nil;
    }
}

- (NSDictionary *)selectLastDowntimeToday {
    /*
     Offline history table stores results in date time format, which is why we perform a LIKE query using only date.
     We return the most recent date and time with ORDER BY and limit the retrieval to one row.
     */
    NSString *commandString = [NSString stringWithFormat:@"SELECT * FROM offline_history WHERE offlineDateTime LIKE '%@%%' AND storeNum = 'All' ORDER BY offlineDateTime DESC LIMIT 1",
                               [DateHelper currentDate]];
    NSArray *results = [self.databaseManager executeQuery:[commandString UTF8String]];
    if ([results count]) {
        return results[0];
    } else {
        return nil;
    }
}

- (NSDictionary *)selectStoreIfHasBeenOfflineToday:(NSString *)storeNumber {
    // Selects most recent offline entry for the store today.
    NSString *commandString = [NSString stringWithFormat:@"SELECT * FROM offline_history WHERE offlineDateTime LIKE '%@%%' AND storeNum = '%@' ORDER BY offlineDateTime DESC LIMIT 1", [DateHelper currentDate], storeNumber];
    
    NSArray *results = [self.databaseManager executeQuery:[commandString UTF8String]];
    
    if ([results count]) {
        NSDictionary *row = results[0];
        
        if ([[row objectForKey:@"status"] isEqualToString:@"C"]) {
            return row;
        }
        
        if ([[row objectForKey:@"status"] isEqualToString:@"M"]) {
            return row;
        }
        
        if ([[row objectForKey:@"status"] isEqualToString:@"T"]) {
            return row;
        }
        
        if ([row objectForKey:@"status"] == nil) {
            return row;
        }
        
        return nil;
    }
    
    return nil;
}

#pragma mark - Helper Methods -

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

- (NSMutableArray *)arrayResultsWithoutNil:(NSMutableArray *)results{
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (int i = 0; i < [results count]; i++) {
        if([results[i] objectForKey:@"state"]!= nil){
            [mutableArray addObject:[results[i] objectForKey:@"state"]];
        }
    }
    return mutableArray;
}





/*!
 * Selects all states from store_detail table
 * Delete duplicated state
 * Put them into array
 */
- (NSMutableArray *)selectStatesInStoreDetail {
    NSString *commandString = [NSString stringWithFormat:@"SELECT DISTINCT state FROM %@ ORDER BY state", StoreTableName];
    NSMutableArray *StateList = [self arrayResultsWithoutNil:[self.databaseManager executeQuery:[commandString UTF8String]]];
    return StateList;
}

/*
 * Select all cities of one state
 */
- (NSMutableArray *)selectCitiesInStoreDetailWithState:(NSString *)state {
    
    NSString *commandString = [NSString stringWithFormat:@"SELECT city FROM %@ WHERE state = '%@' ORDER BY city", StoreTableName, state];
    NSMutableArray *CityList = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"city"];
    
    return CityList;
}

/*
 * Select all stores of one city
 */
- (NSMutableArray *)selectStoresInStoreDetailWithCity:(NSString *)city {
    
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum FROM %@ WHERE city = '%@' ORDER BY storeNum", StoreTableName, city];
    NSMutableArray *StoreList = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"storeNum"];
    
    return StoreList;
}

@end
