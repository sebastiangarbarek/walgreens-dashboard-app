//
//  DatabaseController.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 27/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DatabaseManager;

@interface Commands : NSObject

- (instancetype)initWithDatabaseManager:(DatabaseManager *)databaseManager;

@property DatabaseManager* databaseManager;

@end
