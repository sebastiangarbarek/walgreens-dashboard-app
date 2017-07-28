//
//  DatabaseManagerApp.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 29/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DatabaseManagerApp.h"

@implementation DatabaseManagerApp

- (instancetype)init {
    self = [super init];
    if (self) {
        [self openCreateDatabase];
    }
    return self;
}

- (BOOL)openCreateDatabase {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *databasePath = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:databaseName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:databasePath]) {
        [self copyInitialDatabaseWith:databasePath];
    }
    
    return sqlite3_open([databasePath UTF8String], &database);
}

- (void)copyInitialDatabaseWith:(NSString *)destinationPath {
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:nil];
}

@end
