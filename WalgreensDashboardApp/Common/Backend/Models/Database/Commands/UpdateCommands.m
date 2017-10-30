//
//  UpdateController.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 27/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "UpdateCommands.h"

#import "DatabaseManager.h"
#import "DatabaseConstants.h"

@implementation UpdateCommands

#pragma mark - Store Detail -

- (void)deleteStoreFromStoreDetailTable:(NSString *)storeNumber {
    NSString *commandString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE storeNum = %@", kStoreTableName, storeNumber];
    [self.databaseManager executeCommand:[commandString UTF8String]];
}

#pragma mark - Offline History -

- (void)updateDateTimeOnlineForStore:(NSString *)storeNumber offlineDateTime:(NSString *)offlineDateTime onlineDateTime:(NSString *)onlineDateTime {
    NSString *commandString = [NSString stringWithFormat:@"UPDATE offline_history SET onlineDateTime = '%@' WHERE storeNum = '%@' AND offlineDateTime = '%@'",
                               onlineDateTime, storeNumber, offlineDateTime];
    [self.databaseManager executeCommand:[commandString UTF8String]];
}

@end
