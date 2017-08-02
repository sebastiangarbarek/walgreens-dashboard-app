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

#pragma mark - Override -

- (BOOL)openCreateDatabase {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    databasePath = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:databaseName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:databasePath]) {
        [self copyInitialDatabase];
    }
    
    self.tableCommands = [[TableCommands alloc] initWithDatabaseManager:self];
    self.insertCommands = [[InsertCommands alloc] initWithDatabaseManager:self];
    self.selectCommands = [[SelectCommands alloc] initWithDatabaseManager:self];
    self.updateCommands = [[UpdateCommands alloc] initWithDatabaseManager:self];
    
    int code = sqlite3_open_v2([databasePath UTF8String], &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_FULLMUTEX, nil);
    if (code == SQLITE_OK)
        return YES;
    else
        return NO;
}

@end
