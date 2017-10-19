//
//  UpdateController.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 27/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "UpdateCommands.h"
#import "DatabaseManager.h"

@implementation UpdateCommands

- (void)deleteOfflineStoresInDetailTable {
    NSString *commandString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE status = 0", StoreTableName];
    [self.databaseManager executeCommand:[commandString UTF8String]];
}

- (void)deletePastTempStatuses {
    NSString *commandString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE date != '%@'", TempStatusTableName, [DateHelper currentDate]];
    [self.databaseManager executeCommand:[commandString UTF8String]];
}

- (void)deleteStoreFromStoreDetailTable:(NSString *)storeNumber {
    NSString *commandString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE storeNum = %@", StoreTableName, storeNumber];
    [self.databaseManager executeCommand:[commandString UTF8String]];
}

#pragma mark - Offline History -

- (void)updateDateTimeOnlineForStore:(NSString *)storeNumber offlineDateTime:(NSString *)offlineDateTime onlineDateTime:(NSString *)onlineDateTime {
    NSString *commandString = [NSString stringWithFormat:@"UPDATE offline_history SET onlineDateTime = '%@' WHERE storeNum = '%@' AND offlineDateTime = '%@'",
                               onlineDateTime, storeNumber, offlineDateTime];
    [self.databaseManager executeCommand:[commandString UTF8String]];
}

@end
