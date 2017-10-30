//
//  Controller.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 23/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "Controller.h"

@implementation Controller

- (instancetype)initWithManager:(DatabaseManager *)manager {
    self  = [self init];
    if (self) {
        databaseManager = manager;
        [databaseManager openCreateDatabase];
        startSemaphore = dispatch_semaphore_create(0);
        walgreensApi = [[WalgreensAPI alloc] initWithStartSemaphore:startSemaphore];
    }
    return self;
}

- (void)closeDatabase {
    [databaseManager closeDatabase];
}

@end
