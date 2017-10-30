//
//  InsertManager.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 27/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "Commands.h"
#import "DateHelper.h"

@interface InsertCommands : Commands

- (void)insertOnlineStoreWithData:(NSDictionary *)responseData;
- (void)insertProductsWithData:(NSDictionary *)responseData;
- (void)insertOfflineHistoryWithStore:(NSString *)storeNumber status:(NSString *)status;
- (void)insertTestOfflineHistoryWithStore:(NSNumber *)storeNumber status:(NSString *)status day:(NSNumber *)day month:(NSNumber *)month year:(NSNumber *)year;

@end
