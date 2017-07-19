//
//  DatabaseManager.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 26/05/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DatabaseManager.h"

/*
 This class is used as wrapper class for SQLite database interaction in the app.
 Query results are returned as an array of dictionaries, with each dictionary representing a row in the result set. 
 Data is mapped to column names as keys. A limitation of this helper class is that all data is parsed to NSString,
 as the data returned in a column is unknown to this class. Data is also added to each dictionary key even if it is null.
 When using this class, results should therefore be cast to their data type and values checked for null.
 */
@interface DatabaseManager()

@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSString *databasePath;

// Private helper methods.
- (BOOL)databaseExistsInDocumentsDirectory;
- (void)copyInitialDatabaseIntoDocumentsDirectory;
- (sqlite3_stmt *)prepareDatabaseAndStatementWithCommand:(const char *)command;

@end

@implementation DatabaseManager {
    sqlite3 *sqlite3Database;
}

NSString *const WalgreensAPIDatabaseFilename = @"walgreensapidb.sql";

#pragma mark - Init Methods -

- (instancetype)initWithDatabaseFilename:(NSString *)databaseFilename {
    self = [super init];
    
    if (self) {
        // Store the database filename.
        self.databaseFilename = databaseFilename;
        
        // Get and set the path to the document directory.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.databasePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:self.databaseFilename];
        
        if (![self databaseExistsInDocumentsDirectory]) {
            // Make a copy of the initial database from the bundle into the documents directory.
            [self copyInitialDatabaseIntoDocumentsDirectory];
        }
    }
    
    return self;
}

- (BOOL)databaseExistsInDocumentsDirectory {
    return [[NSFileManager defaultManager] fileExistsAtPath:self.databasePath];
}

/* 
 We want to create a writable copy of the bundled database.
 This method is executed once per app install.
 */
-(void)copyInitialDatabaseIntoDocumentsDirectory {
    // Get the path to the initial database in the bundle.
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
    
    // Copy the initial database from the bundle.
    NSError *error;
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:self.databasePath error:&error];
    
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

#pragma mark - SQLite Wrapper Methods -

- (NSMutableArray *)executeQuery:(const char *)query {
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *compiledStatement = [self prepareDatabaseAndStatementWithCommand:query];
    
    if (compiledStatement != nil) {
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            int totalColumns = sqlite3_column_count(compiledStatement);
            
            NSMutableDictionary *rowData = [[NSMutableDictionary alloc] init];
            
            // Go through each column for this row.
            for (int i = 0; i < totalColumns; i++) {
                // Get the data.
                NSString *data = [NSString stringWithFormat:@"%s", sqlite3_column_text(compiledStatement, i)];
                NSString *columnName = [NSString stringWithFormat:@"%s", sqlite3_column_name(compiledStatement, i)];
                
                // Add data regardless if it is null. Null checking should be performed when using the results.
                [rowData setObject:data forKey:columnName];
            }
            
            // Add the dictionary holding the data in the row to the results array.
            [results addObject:rowData];
        }
        
        // Close all SQLite resources.
        sqlite3_finalize(compiledStatement);
        sqlite3_close(sqlite3Database);
    }
    
    return results;
}

- (void)executeStatement:(const char *)command {
    sqlite3_stmt *compiledStatement = [self prepareDatabaseAndStatementWithCommand:command];
    
    if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
        NSLog(@"Failed to execute statement: %s. \n SQLite Error: %s", command, sqlite3_errmsg(sqlite3Database));
    }
    
    // Close all SQLite resources.
    sqlite3_finalize(compiledStatement);
    sqlite3_close(sqlite3Database);
}

#pragma mark - Class Helper Methods -

- (sqlite3_stmt *)prepareDatabaseAndStatementWithCommand:(const char*)command {
    BOOL openDatabase = sqlite3_open([self.databasePath UTF8String], &sqlite3Database);
    
    if (openDatabase == SQLITE_OK) {
        // This will channel the results of a query.
        sqlite3_stmt *compiledStatement;
        
        BOOL prepareStatement = sqlite3_prepare_v2(sqlite3Database, command, -1, &compiledStatement, NULL);
        
        if (prepareStatement == SQLITE_OK) {
            return compiledStatement;
        } else {
            NSLog(@"Failed to prepare statement. \n SQLite Error: %s", sqlite3_errmsg(sqlite3Database));
        }
    } else {
        NSLog(@"Failed to open database. \n SQLite Error: %s", sqlite3_errmsg(sqlite3Database));
    }
    
    return nil;
}

@end
