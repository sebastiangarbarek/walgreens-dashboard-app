//
//  DatabaseManager.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 25/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DatabaseManager.h"

@implementation DatabaseManager

- (BOOL)openCreateDatabase {
    if (!database) {
        NSArray *supportDirectoryPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *databaseDirectory = [supportDirectoryPaths objectAtIndex:0];
        databasePath = [databaseDirectory stringByAppendingPathComponent:databaseName];
        if (sqlite3_open_v2([databasePath UTF8String], &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil)
            == SQLITE_OK) {
            self.tableCommands = [[TableCommands alloc] initWithDatabaseManager:self];
            self.insertCommands = [[InsertCommands alloc] initWithDatabaseManager:self];
            self.selectCommands = [[SelectCommands alloc] initWithDatabaseManager:self];
            self.updateCommands = [[UpdateCommands alloc] initWithDatabaseManager:self];
            
            [self.tableCommands openCreateTables];
        }
    }
    
    return YES;
}

- (void)executeCommand:(const char *)command {
    [self executeStatement:[self createStatementWithCommand:command]];
}

- (sqlite3_stmt *)createStatementWithCommand:(const char *)command {
    sqlite3_stmt *compiledStatement;
    
    int code;
    BOOL retry;
    
    do {
        retry = NO;
        code = sqlite3_prepare_v2(database, command, -1, &compiledStatement, NULL);
        switch (code) {
            case SQLITE_BUSY:
                retry = YES;
                break;
            case SQLITE_OK:
                return compiledStatement;
                break;
            case SQLITE_ERROR:
                printf("[HARVESTER 🍎] %s\n", sqlite3_errmsg(database));
                break;
        }
    } while (retry);
    
    return nil;
}

- (void)executeStatement:(sqlite3_stmt *)statement {
    if (statement) {
        int code;
        BOOL retry;
        
        do {
            retry = NO;
            code = sqlite3_step(statement);
            switch (code) {
                case SQLITE_BUSY:
                    retry = YES;
                    break;
                case SQLITE_DONE:
                    break;
                case SQLITE_ERROR:
                    printf("[HARVESTER 🍎] %s\n", sqlite3_errmsg(database));
                    break;
            }
        } while (retry);
        
        sqlite3_finalize(statement);
    }
}

- (NSMutableArray *)executeQuery:(const char *)query {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement = [self createStatementWithCommand:query];
    
    if (statement != nil) {
        int code;
        do {
            code = sqlite3_step(statement);
            switch (code) {
                case SQLITE_BUSY:
                    break;
                case SQLITE_ROW: {
                    int totalColumns = sqlite3_column_count(statement);
                    
                    NSMutableDictionary *rowData = [[NSMutableDictionary alloc] init];
                    
                    for (int i = 0; i < totalColumns; i++) {
                        NSString *columnName = [NSString stringWithFormat:@"%s", sqlite3_column_name(statement, i)];
                        
                        switch (sqlite3_column_type(statement, i)) {
                            case SQLITE_INTEGER: {
                                NSNumber *data = [NSNumber numberWithInt:sqlite3_column_int(statement, i)];
                                [rowData setObject:data forKey:columnName];
                                break;
                            }
                            case SQLITE_TEXT: {
                                NSString *data = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)];
                                [rowData setObject:data forKey:columnName];
                                break;
                            }
                        }
                    }

                    [results addObject:rowData];
                    break;
                }
                case SQLITE_ERROR:
                    printf("[HARVESTER 🍎] %s\n", sqlite3_errmsg(database));
                    break;
            }
        } while (code != SQLITE_DONE);
        
        sqlite3_finalize(statement);
    }
    
    return results;
}

- (NSDate *)sqliteDateFromString:(NSString *)dateString {
    sqlite3_stmt *statement = [self createStatementWithCommand:"SELECT strftime('%s', ?)"];
    sqlite3_bind_text(statement, 1, [dateString UTF8String], -1, SQLITE_STATIC);
    
    int code;
    do {
        code = sqlite3_step(statement);
    } while (code == SQLITE_BUSY);
    
    sqlite3_int64 interval = sqlite3_column_int64(statement, 0);
    sqlite3_finalize(statement);
    
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

- (BOOL)databaseExists {
    return [[NSFileManager defaultManager] fileExistsAtPath:databasePath];
}

- (void)deleteDatabase {
    [[NSFileManager defaultManager] removeItemAtPath:databasePath error:nil];
}

- (void)openDatabase {
    if (database == nil) sqlite3_open([databasePath UTF8String], &database);
}

- (void)closeDatabase {
    if (database) {
        sqlite3_close(database);
        database = nil;
    }
}

@end
