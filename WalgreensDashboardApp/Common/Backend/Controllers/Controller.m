//
//  Controller.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 23/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "Controller.h"

@implementation Controller

- (instancetype)init {
    self  = [super init];
    if (self) {
        startingThreadSemaphore = dispatch_semaphore_create(0);
        walgreensApi = [[WalgreensAPI alloc] initWithSemaphore:startingThreadSemaphore];
        databaseManager = [[DatabaseManager alloc] init];
    }
    return self;
}

- (instancetype)initWithManager:(DatabaseManager *)dbManager {
    self  = [self init];
    if (self) {
        databaseManager = dbManager;
        [databaseManager openCreateDatabase];
    }
    return self;
}

- (void)closeDatabase {
    [databaseManager closeDatabase];
}

@end
