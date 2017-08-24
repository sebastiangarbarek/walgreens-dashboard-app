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

@end
