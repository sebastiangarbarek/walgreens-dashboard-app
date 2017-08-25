//
//  DatabaseController.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 27/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "Commands.h"
#import "DatabaseManager.h"

@implementation Commands

- (instancetype)initWithDatabaseManager:(DatabaseManager *)databaseManager {
    self = [super self];
    if (self) {
        self.databaseManager = databaseManager;
    }
    return self;
}

@end
