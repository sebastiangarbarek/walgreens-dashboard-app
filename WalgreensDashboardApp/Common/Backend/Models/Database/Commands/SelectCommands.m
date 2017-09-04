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

- (NSMutableArray *)selectDatesInHistoryTable {
    NSString *commandString = [NSString stringWithFormat:@"SELECT date FROM %@", HistoryTableName];
    return [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"date"];
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

- (NSMutableArray *)arrayResultsWithoutNil:(NSMutableArray *)results{
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (int i = 0; i < [results count]; i++) {
        if([results[i] objectForKey:@"state"]!= nil){
            [mutableArray addObject:results[i]];
        }
    }
    return mutableArray;
}

/* Selects all the stores that open twenty four hours for whole week
 */

- (NSNumber *) selectTwentyFourHourStores {
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE twentyFourHr ='%s' && photoInd = true", StoreTableName, "Y"];
    NSArray* results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"COUNT(*)"];
    if ([results count])
        return (NSNumber *) results[0];
    else
        return nil;
}

- (NSNumber *) selectMondayTwentyFourHour {
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE mon24hrs = '%d'", StoreHourTableName, 1];
    NSArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"COUNT(*)"];
    if ([results count])
        return (NSNumber *) results[0];
    else
        return nil;
}


- (NSNumber *) selectTuesdaywentyFourHour {
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE tue24hrs = '%d'", StoreHourTableName, 1];
    NSArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"COUNT(*)"];
    if ([results count])
        return (NSNumber *) results[0];
    else
        return nil;
}



- (NSNumber *) selectWednesdayTwentyFourHour {
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE wed4hrs = '%d'", StoreHourTableName, 1];
    NSArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"COUNT(*)"];
    if ([results count])
        return (NSNumber *) results[0];
    else
        return nil;
}



- (NSNumber *) selectThusdayTwentyFourHour {
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE thu24hrs = '%d'", StoreHourTableName, 1];
    NSArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"COUNT(*)"];
    if ([results count])
        return (NSNumber *) results[0];
    else
        return nil;
}



- (NSNumber *) selectFridayTwentyFourHour {
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE fri4hrs = '%d'", StoreHourTableName, 1];
    NSArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"COUNT(*)"];
    if ([results count])
        return (NSNumber *) results[0];
    else
        return nil;
}



- (NSNumber *) selectSaturdayTwentyFourHour {
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE sat24hrs = '%d'", StoreHourTableName, 1];
    NSArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"COUNT(*)"];
    if ([results count])
        return (NSNumber *) results[0];
    else
        return nil;
}



- (NSNumber *) selectSundayTwentyFourHour {
    NSString *commandString = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE sun24hrs = '%d'", StoreHourTableName, 1];
    NSArray *results = [self arrayWithResults:[self.databaseManager executeQuery:[commandString UTF8String]] key:@"COUNT(*)"];
    if ([results count])
        return (NSNumber *) results[0];
    else
        return nil;
}

// Selects opening hours and store it in MutableArray

-(NSMutableDictionary *) selectMondayOpeningHours {
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum, monOpen, monClose FROM %@", StoreHourTableName];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject: [self.databaseManager executeQuery: [commandString UTF8String]] forKey:@"storeNum"];
    id object = [dict objectForKey:@"storeNum"];
    return object;

}

-(NSMutableDictionary *) selectTuesdayOpeningHours {
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum, tueOpen, tueClose FROM %@", StoreHourTableName];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject: [self.databaseManager executeQuery: [commandString UTF8String]] forKey:@"storeNum"];
    id object = [dict objectForKey:@"storeNum"];
    return object;
}


-(NSMutableDictionary *) selectWednesdayOpeningHours {
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum, wedOpen, wedClose FROM %@", StoreHourTableName];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject: [self.databaseManager executeQuery: [commandString UTF8String]] forKey:@"storeNum"];
    id object = [dict objectForKey:@"storeNum"];
    return object;
    
}

-(NSMutableDictionary *) selectThusdayOpeningHours {
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum, thuOpen, thuClose FROM %@", StoreHourTableName];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject: [self.databaseManager executeQuery: [commandString UTF8String]] forKey:@"storeNum"];
    id object = [dict objectForKey:@"storeNum"];
    return object;
    
}

-(NSMutableDictionary *) selectFridayOpeningHours {
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum, friOpen, friClose FROM %@", StoreHourTableName];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject: [self.databaseManager executeQuery: [commandString UTF8String]] forKey:@"storeNum"];
    id object = [dict objectForKey:@"storeNum"];
    return object;
    
}

-(NSMutableDictionary*) selectSaturdayOpeningHours {
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum, satOpen, satClose FROM %@", StoreHourTableName];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject: [self.databaseManager executeQuery: [commandString UTF8String]] forKey:@"storeNum"];
    id object = [dict objectForKey:@"storeNum"];
    return object;
    
}

-(NSMutableDictionary *) selectSundayOpeningHours {
    NSString *commandString = [NSString stringWithFormat:@"SELECT storeNum, sunOpen, sunClose FROM %@", StoreHourTableName];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject: [self.databaseManager executeQuery: [commandString UTF8String]] forKey:@"storeNum"];
    id object = [dict objectForKey:@"storeNum"];
    return object;
    
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
