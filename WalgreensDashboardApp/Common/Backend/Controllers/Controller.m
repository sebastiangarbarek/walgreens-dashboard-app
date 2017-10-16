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
        startSemaphore = dispatch_semaphore_create(0);
        walgreensApi = [[WalgreensAPI alloc] initWithStartSemaphore:startSemaphore];
        databaseManager = [[DatabaseManager alloc] init];
    }
    return self;
}

- (instancetype)initWithManager:(DatabaseManager *)manager {
    self  = [self init];
    if (self) {
        databaseManager = manager;
        [databaseManager openCreateDatabase];
    }
    return self;
}

- (void)closeDatabase {
    [databaseManager closeDatabase];
}

@end
