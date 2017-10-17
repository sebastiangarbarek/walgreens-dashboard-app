//
//  Controller.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 23/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WalgreensAPI.h"
#import "NetworkUtility.h"
#import "DatabaseManager.h"

@interface Controller : NSObject {
    WalgreensAPI *walgreensApi;
    DatabaseManager *databaseManager;
    dispatch_semaphore_t startSemaphore;
}

- (instancetype)initWithManager:(DatabaseManager *)manager;

- (void)closeDatabase;

@end
