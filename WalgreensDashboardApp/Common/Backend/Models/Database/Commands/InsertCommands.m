//
//  InsertManager.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 27/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "InsertCommands.h"
#import "DatabaseManager.h"

@implementation InsertCommands

- (void)insertOnlineStoreWithData:(NSDictionary *)responseData {
    NSDictionary *storeDetails = [responseData objectForKey:@"store"];
    
    NSString *commandString = [NSString stringWithFormat:@"INSERT INTO %@ (storeNum, address1, address2, street, streetAddr2, city, state, country, county, districtNum, storeAreaCd, formattedIntersection, intersection, latitude, longitude, storeTimeZone, timezone, dayltTimeOffset, stdTimeOffset, timeOffsetCode, twentyFourHr, photoInd, photoStatusCd, storePhotoStatusCd, inkjeti, storeStatus, intlPhoneNumber, storePhoneNum, status, updateDtTime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", StoreTableName];
    const char *insertStoreDetailsCmd = [commandString UTF8String];
    
    sqlite3_stmt *insertStoreDetailsStmt = [self.databaseManager createStatementWithCommand:insertStoreDetailsCmd];
    
    sqlite3_bind_int(insertStoreDetailsStmt, 1, [[storeDetails objectForKey:@"storeNum"] intValue]);
    
    // Location fields.
    sqlite3_bind_text(insertStoreDetailsStmt, 2, [[[storeDetails objectForKey:@"address1"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 3, [[[storeDetails objectForKey:@"address2"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 4, [[[storeDetails objectForKey:@"street"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 5, [[[storeDetails objectForKey:@"streetAddr2"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 6, [[[storeDetails objectForKey:@"city"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 7, [[[storeDetails objectForKey:@"state"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 8, [[[storeDetails objectForKey:@"country"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 9, [[[storeDetails objectForKey:@"county"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 10, [[[storeDetails objectForKey:@"districtNum"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 11, [[[storeDetails objectForKey:@"storeAreaCd"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 12, [[[storeDetails objectForKey:@"formattedIntersection"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 13, [[[storeDetails objectForKey:@"intersection"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 14, [[[storeDetails objectForKey:@"longitude"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 15, [[[storeDetails objectForKey:@"latitude"] description] UTF8String], -1, SQLITE_STATIC);
    
    // Time fields.
    sqlite3_bind_text(insertStoreDetailsStmt, 16, [[[storeDetails objectForKey:@"storeTimeZone"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 17, [[[storeDetails objectForKey:@"timezone"] description] UTF8String], -1, SQLITE_STATIC);
    [self bindIntValue:[storeDetails objectForKey:@"dayltTimeOffset"] withPosition:18 andStatement:insertStoreDetailsStmt];
    [self bindIntValue:[storeDetails objectForKey:@"stdTimeOffset"] withPosition:19 andStatement:insertStoreDetailsStmt];
    [self bindIntValue:[storeDetails objectForKey:@"timeOffsetCode"] withPosition:20 andStatement:insertStoreDetailsStmt];
    sqlite3_bind_text(insertStoreDetailsStmt, 21, [[[storeDetails objectForKey:@"twentyFourHr"] description] UTF8String], -1, SQLITE_STATIC);
    
    // Status fields.
    sqlite3_bind_text(insertStoreDetailsStmt, 22, [[[storeDetails objectForKey:@"photoInd"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 23, [[[responseData objectForKey:@"photoStatusCd"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 24, [[[storeDetails objectForKey:@"storePhotoStatusCd"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 25, [[[storeDetails objectForKey:@"inkjeti"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 26, [[[storeDetails objectForKey:@"storeStatus"] description] UTF8String], -1, SQLITE_STATIC);
    
    // Contact fields.
    sqlite3_bind_text(insertStoreDetailsStmt, 27, [[[storeDetails objectForKey:@"intlPhoneNumber"] description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(insertStoreDetailsStmt, 28, [[[storeDetails objectForKey:@"storePhoneNum"] description] UTF8String], -1, SQLITE_STATIC);
    
    // App fields.
    sqlite3_bind_int(insertStoreDetailsStmt, 29, 1);
    sqlite3_bind_text(insertStoreDetailsStmt, 30, [[[DateHelper currentDateAndTime] description] UTF8String], -1, SQLITE_STATIC);
    
    [self.databaseManager executeStatement:insertStoreDetailsStmt];
    
    [self insertStoreHoursWithData:responseData];
}

- (void)insertOfflineStoreWithStoreNumber:(NSString *)storeNumber {
    NSString *storeCommandString = [NSString stringWithFormat:@"INSERT INTO %@ (storeNum, status, updateDtTime) VALUES (?, ?, ?)", StoreTableName];
    const char *insertStoreDetailsCmd = [storeCommandString UTF8String];
    
    sqlite3_stmt *insertStoreDetailsStmt = [self.databaseManager createStatementWithCommand:insertStoreDetailsCmd];
    sqlite3_bind_int(insertStoreDetailsStmt, 1, [storeNumber intValue]);
    sqlite3_bind_int(insertStoreDetailsStmt, 2, 0);
    sqlite3_bind_text(insertStoreDetailsStmt, 3, [[[DateHelper currentDateAndTime] description] UTF8String], -1, SQLITE_STATIC);

    [self.databaseManager executeStatement:insertStoreDetailsStmt];
    
    NSString *hoursCommandString = [NSString stringWithFormat:@"INSERT INTO %@ (storeNum, updateDtTime) VALUES (?, ?)", StoreHourTableName];
    const char *insertStoreHoursCmd = [hoursCommandString UTF8String];
    
    sqlite3_stmt *insertStoreHoursStmt = [self.databaseManager createStatementWithCommand:insertStoreHoursCmd];
    sqlite3_bind_int(insertStoreHoursStmt, 1, [storeNumber intValue]);
    sqlite3_bind_text(insertStoreHoursStmt, 2, [[[DateHelper currentDateAndTime] description] UTF8String], -1, SQLITE_STATIC);
    
    [self.databaseManager executeStatement:insertStoreHoursStmt];
}

- (void)insertStoreHoursWithData:(NSDictionary *)responseData {
    NSDictionary *storeHours = [responseData objectForKey:@"storeHr"];
    
    if (storeHours) {
        NSString *commandString = [NSString stringWithFormat:@"INSERT INTO %@ (storeNum, avail, monOpen, monClose, mon24Hrs, tueOpen, tueClose, tue24Hrs, wedOpen, wedClose, wed24Hrs, thuOpen, thuClose, thu24Hrs, friOpen, friClose, fri24Hrs, satOpen, satClose, sat24Hrs, sunOpen, sunClose, sun24Hrs, wkdaySamelnd, hourType, updateDtTime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", StoreHourTableName];
        const char *insertStoreHoursCmd = [commandString UTF8String];
        
        sqlite3_stmt *insertStoreHoursStmt = [self.databaseManager createStatementWithCommand:insertStoreHoursCmd];
        
        sqlite3_bind_int(insertStoreHoursStmt, 1, [[storeHours objectForKey:@"storeNum"] intValue]);
        
        // Date fields.
        sqlite3_bind_text(insertStoreHoursStmt, 2, [[[storeHours objectForKey:@"avail"] description] UTF8String], -1, SQLITE_STATIC);
        
        sqlite3_bind_text(insertStoreHoursStmt, 3, [[[storeHours objectForKey:@"monOpen"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertStoreHoursStmt, 4, [[[storeHours objectForKey:@"monClose"] description] UTF8String], -1, SQLITE_STATIC);
        [self bindIntValue:[storeHours objectForKey:@"mon24Hrs"] withPosition:5 andStatement:insertStoreHoursStmt];
        
        sqlite3_bind_text(insertStoreHoursStmt, 6, [[[storeHours objectForKey:@"tueOpen"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertStoreHoursStmt, 7, [[[storeHours objectForKey:@"tueClose"] description] UTF8String], -1, SQLITE_STATIC);
        [self bindIntValue:[storeHours objectForKey:@"tue24Hrs"] withPosition:8 andStatement:insertStoreHoursStmt];
        
        sqlite3_bind_text(insertStoreHoursStmt, 9, [[[storeHours objectForKey:@"wedOpen"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertStoreHoursStmt, 10, [[[storeHours objectForKey:@"wedClose"] description] UTF8String], -1, SQLITE_STATIC);
        [self bindIntValue:[storeHours objectForKey:@"wed24Hrs"] withPosition:11 andStatement:insertStoreHoursStmt];
        
        sqlite3_bind_text(insertStoreHoursStmt, 12, [[[storeHours objectForKey:@"thuOpen"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertStoreHoursStmt, 13, [[[storeHours objectForKey:@"thuClose"] description] UTF8String], -1, SQLITE_STATIC);
        [self bindIntValue:[storeHours objectForKey:@"thu24Hrs"] withPosition:14 andStatement:insertStoreHoursStmt];
        
        sqlite3_bind_text(insertStoreHoursStmt, 15, [[[storeHours objectForKey:@"friOpen"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertStoreHoursStmt, 16, [[[storeHours objectForKey:@"friClose"] description] UTF8String], -1, SQLITE_STATIC);
        [self bindIntValue:[storeHours objectForKey:@"fri24Hrs"] withPosition:17 andStatement:insertStoreHoursStmt];
        
        sqlite3_bind_text(insertStoreHoursStmt, 18, [[[storeHours objectForKey:@"satOpen"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertStoreHoursStmt, 19, [[[storeHours objectForKey:@"satClose"] description] UTF8String], -1, SQLITE_STATIC);
        [self bindIntValue:[storeHours objectForKey:@"sat24Hrs"] withPosition:20 andStatement:insertStoreHoursStmt];
        
        sqlite3_bind_text(insertStoreHoursStmt, 21, [[[storeHours objectForKey:@"sunOpen"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertStoreHoursStmt, 22, [[[storeHours objectForKey:@"sunClose"] description] UTF8String], -1, SQLITE_STATIC);
        [self bindIntValue:[storeHours objectForKey:@"sun24Hrs"] withPosition:23 andStatement:insertStoreHoursStmt];
        
        [self bindIntValue:[storeHours objectForKey:@"wkdaySameInd"] withPosition:24 andStatement:insertStoreHoursStmt];
        sqlite3_bind_text(insertStoreHoursStmt, 25, [[[storeHours objectForKey:@"hourType"] description] UTF8String], -1, SQLITE_STATIC);
        
        // App fields.
        sqlite3_bind_text(insertStoreHoursStmt, 27, [[[DateHelper currentDateAndTime] description] UTF8String], -1, SQLITE_STATIC);
        
        [self.databaseManager executeStatement:insertStoreHoursStmt];
    }
}

- (void)insertProductsWithData:(NSDictionary *)responseData {
    NSArray *products = [responseData valueForKey:@"products"];
    
    for(int i = 0; i < [products count]; i++) {
        NSDictionary *product = products[i];
        
        NSString *commandString = [NSString stringWithFormat:@"INSERT INTO %@ (productId, productGroupId, productDesc, productPrice, currencyType, productSize, offsetWidth, offsetHeight, resWidth, resHeight, dpi, multiImageIndicator, boxQty, vendorQtyLimit, templateUrl, updateDtTime) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", ProductTableName];
        const char* insertProductsCmd = [commandString UTF8String];
        
        sqlite3_stmt *insertProductsStmt = [self.databaseManager createStatementWithCommand:insertProductsCmd];
        
        // Product information.
        sqlite3_bind_text(insertProductsStmt, 1, [[[product objectForKey:@"productId"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertProductsStmt, 2, [[[product objectForKey:@"productGroupId"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertProductsStmt, 3, [[[product objectForKey:@"productDesc"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertProductsStmt, 4, [[[product objectForKey:@"productPrice"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertProductsStmt, 5, [[[product objectForKey:@"currencyType"] description] UTF8String], -1, SQLITE_STATIC);
        
        // Sizing information.
        sqlite3_bind_text(insertProductsStmt, 6, [[[product objectForKey:@"productSize"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertProductsStmt, 7, [[[product objectForKey:@"offsetWidth"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertProductsStmt, 8, [[[product objectForKey:@"offsetHeight"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertProductsStmt, 9, [[[product objectForKey:@"resWidth"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertProductsStmt, 10, [[[product objectForKey:@"resHeight"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertProductsStmt, 11, [[[product objectForKey:@"dpi"] description] UTF8String], -1, SQLITE_STATIC);
        
        // Other information.
        sqlite3_bind_text(insertProductsStmt, 12, [[[product objectForKey:@"multiImageIndicator"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertProductsStmt, 13, [[[product objectForKey:@"boxQty"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertProductsStmt, 14, [[[product objectForKey:@"vendorQtyLimit"] description] UTF8String], -1, SQLITE_STATIC);
        sqlite3_bind_text(insertProductsStmt, 15, [[[product objectForKey:@"templateUrl"] description] UTF8String], -1, SQLITE_STATIC);
        
        sqlite3_bind_text(insertProductsStmt, 16, [[[DateHelper currentDateAndTime] description] UTF8String], -1, SQLITE_STATIC);
        
        [self.databaseManager executeStatement:insertProductsStmt];
    }
}

- (void)insertOfflineHistoryWithStore:(NSString *)storeNumber {
    NSString *commandString = [NSString stringWithFormat:@"INSERT INTO %@ (storeNum, offlineDateTime) VALUES (?,?)", HistoryTableName];
    const char *command = [commandString UTF8String];
    sqlite3_stmt *statement = [self.databaseManager createStatementWithCommand:command];
    
    sqlite3_bind_text(statement, 1, [[storeNumber description] UTF8String], -1, SQLITE_STATIC);
    sqlite3_bind_text(statement, 2, [[[DateHelper currentDateAndTime] description] UTF8String], -1, SQLITE_STATIC);
    
    [self.databaseManager executeStatement:statement];
}

- (void)bindIntValue:(id)value withPosition:(int)position andStatement:(sqlite3_stmt *)stmt {
    ([NSNull null] == value) ? sqlite3_bind_null(stmt, position) : sqlite3_bind_int(stmt, position, [value intValue]);
}

@end
