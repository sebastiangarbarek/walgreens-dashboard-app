//
//  DatabaseCreate.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 26/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "Commands.h"

static const NSString *StoreTableName = @"store_detail";
static const NSString *ProductTableName = @"product_detail";
static const NSString *HistoryTableName = @"offline_history";
static const NSString *TempStatusTableName = @"temp_status";
static const NSString *StoreHourTableName = @"store_hour";

@interface TableCommands : Commands

- (void)openCreateTables;
- (void)dropTableWithTableName:(char *)tableName;

@end
