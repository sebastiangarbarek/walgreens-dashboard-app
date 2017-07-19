//
//  DatabaseManager.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 26/05/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DatabaseManager : NSObject

extern NSString *const WalgreensAPIDatabaseFilename;

- (instancetype)initWithDatabaseFilename:(NSString *)databaseFilename;

// Used as helper methods, note that SQLite takes C strings.
- (NSMutableArray *)executeQuery:(const char *)query;
- (void)executeStatement:(const char *)statement;

@end
