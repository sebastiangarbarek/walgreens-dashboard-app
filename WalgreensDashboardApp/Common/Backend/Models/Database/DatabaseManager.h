//
//  DatabaseManager.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 25/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "TableCommands.h"
#import "InsertCommands.h"
#import "SelectCommands.h"
#import "UpdateCommands.h"

static NSString *const databaseName = @"walgreensapidb.sql";

@interface DatabaseManager : NSObject {
    sqlite3 *database;
    NSString *databasePath;
}

- (BOOL)openCreateDatabase;
- (void)executeCommand:(const char *)command;
- (sqlite3_stmt *)createStatementWithCommand:(const char *)command;
- (void)executeStatement:(sqlite3_stmt *)statement;
- (NSMutableArray *)executeQuery:(const char *)query;
- (void)closeDatabase;

@property TableCommands* tableCommands;
@property InsertCommands* insertCommands;
@property SelectCommands* selectCommands;
@property UpdateCommands* updateCommands;

@end
