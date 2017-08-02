//
//  DatabaseManagerApp.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 29/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DatabaseManagerApp.h"

@implementation DatabaseManagerApp

- (void)copyInitialDatabase {
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
    NSError *error;
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:databasePath error:&error];
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

#pragma mark - Overridden Methods -

- (BOOL)openCreateDatabase {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    databasePath = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:databaseName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:databasePath]) {
        [self copyInitialDatabase];
    }
    
    sqlite3_open([databasePath UTF8String], &database);
    
    self.tableCommands = [[TableCommands alloc] initWithDatabaseManager:self];
    self.insertCommands = [[InsertCommands alloc] initWithDatabaseManager:self];
    self.selectCommands = [[SelectCommands alloc] initWithDatabaseManager:self];
    self.updateCommands = [[UpdateCommands alloc] initWithDatabaseManager:self];
    
    // Super method returns success or failure.
    return YES;
}

@end
