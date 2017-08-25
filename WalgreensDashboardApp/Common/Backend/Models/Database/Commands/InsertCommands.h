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
- (void)insertOfflineStoreWithStoreNumber:(NSString *)storeNumber;

- (void)insertProductsWithData:(NSDictionary *)responseData;

- (void)insertOfflineHistoryWithStore:(NSString *)storeNumber;
- (void)insertTempStatusWithStore:(NSString *)storeNumber online:(BOOL)online;

@end
