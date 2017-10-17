//
//  UpdateController.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 27/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "Commands.h"

@interface UpdateCommands : Commands

- (void)deleteOfflineStoresInDetailTable;
- (void)deletePastTempStatuses;
- (void)deleteStoreFromStoreDetailTable:(NSString *)storeNumber;

- (void)updateDateTimeOnlineForStore:(NSString *)storeNumber offlineDateTime:(NSString *)offlineDateTime onlineDateTime:(NSString *)onlineDateTime;

@end
