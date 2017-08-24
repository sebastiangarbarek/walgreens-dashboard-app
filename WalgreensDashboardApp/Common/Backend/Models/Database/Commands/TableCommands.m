//
//  DatabaseCreate.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 26/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "TableCommands.h"
#import "DatabaseManager.h"

@implementation TableCommands

- (void)openCreateTables {
    [self createStoreDetailTable];
    [self createStoreHourTable];
    [self createProductDetailTable];
    [self createHistoryTable];
    [self createTempStatusTable];
}

- (void)createStoreDetailTable {
    NSString *commandString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (storeNum INT PRIMARY KEY, address1 TEXT, address2 TEXT, street TEXT, streetAddr2 TEXT, city TEXT, state TEXT, country TEXT, county TEXT, districtNum TEXT, storeAreaCd TEXT, formattedIntersection TEXT, intersection TEXT, latitude TEXT, longitude TEXT, storeTimeZone TEXT, timezone TEXT, dayltTimeOffset INT, stdTimeOffset INT, timeOffsetCode INT, twentyFourHr TEXT, photoInd TEXT, photoStatusCd TEXT, storePhotoStatusCd TEXT, inkjeti TEXT, storeStatus TEXT, intlPhoneNumber TEXT, storePhoneNum TEXT, status INT, updateDtTime TEXT)", StoreTableName];
    [self.databaseManager executeCommand:[commandString UTF8String]];
}

- (void)createStoreHourTable {
    NSString *commandString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (storeNum INT PRIMARY KEY, avail TEXT, monOpen TEXT, monClose TEXT, mon24Hrs INT, tueOpen TEXT, tueClose TEXT, tue24Hrs INT, wedOpen TEXT, wedClose TEXT, wed24Hrs INT, thuOpen TEXT, thuClose TEXT, thu24Hrs INT, friOpen TEXT, friClose TEXT, fri24Hrs INT, satOpen TEXT, satClose TEXT, sat24Hrs INT, sunOpen TEXT, sunClose TEXT, sun24Hrs INT, wkdaySamelnd INT, hourType TEXT, updateDtTime TEXT)", StoreHourTableName];
    [self.databaseManager executeCommand:[commandString UTF8String]];
}

- (void)createProductDetailTable {
    NSString *commandString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (productId TEXT PRIMARY KEY, productGroupId TEXT, productDesc TEXT, productPrice TEXT, currencyType TEXT, productSize TEXT, offsetWidth TEXT, offsetHeight TEXT, resWidth TEXT, resHeight TEXT, dpi TEXT, multiImageIndicator TEXT, boxQty TEXT, vendorQtyLimit TEXT, templateUrl TEXT, updateDtTime TEXT)", ProductTableName];
    [self.databaseManager executeCommand:[commandString UTF8String]];
}

- (void)createHistoryTable {
    NSString *commandString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (storeNum INT, date TEXT, PRIMARY KEY (storeNum, date) FOREIGN KEY (storeNum) REFERENCES store_detail (storeNum))", HistoryTableName];
    [self.databaseManager executeCommand:[commandString UTF8String]];
}

- (void)createTempStatusTable {
    NSString *commandString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (storeNum INT, date TEXT, status INT, PRIMARY KEY (storeNum, date) FOREIGN KEY (storeNum) REFERENCES store_detail (storeNum))", TempStatusTableName];
    [self.databaseManager executeCommand:[commandString UTF8String]];
}

- (void)dropTableWithTableName:(char *)tableName {
    NSString *commandString = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %s", tableName];
    [self.databaseManager executeCommand:[commandString UTF8String]];
}

@end
