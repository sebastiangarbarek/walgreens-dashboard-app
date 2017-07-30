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
    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:databasePath error:nil];
}

#pragma mark - Overridden Methods -

- (instancetype)init {
    self = [super init];
    if (self) {
        [self openCreateDatabase];
    }
    return self;
}

- (BOOL)openCreateDatabase {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    databasePath = [[documentPaths objectAtIndex:0] stringByAppendingPathComponent:databaseName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:databasePath]) {
        [self copyInitialDatabase];
    }
    
    // Super method returns success or failure.
    return YES;
}

@end
