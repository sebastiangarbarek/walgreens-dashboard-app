//
//  DataController.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 23/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DataController.h"

@implementation DataController

- (instancetype)init {
    self  = [super init];
    if (self) {
        walgreensApi.delegate = self;
    }
    return self;
}

- (void)requestAndInsertAllStoreData {
    [databaseManager.tableCommands dropTableWithTableName:"store_detail"];
    [databaseManager.tableCommands openCreateTables];
    
    printf("[HARVESTER 🍏] Requesting store list...\n");
    [NetworkUtility requestStoreList:^(NSArray *storeList, NSError *sessionError) {
        if (storeList) {
            printf("[HARVESTER 🍏] Store list retrieved successfully...\n");
            [walgreensApi requestAllStoresInList:storeList];
        } else {
            printf("[HARVESTER 🍎] Failed to retrieve store list...\n");
            dispatch_semaphore_signal(startingThreadSemaphore);
        }
    }];
    
    dispatch_semaphore_wait(startingThreadSemaphore, DISPATCH_TIME_FOREVER);
}

- (NSArray *)isStoreDataIncomplete {
    __block NSMutableArray *retrievedStoreList;
    [NetworkUtility requestStoreList:^(NSArray *storeList, NSError *sessionError) {
        if (storeList) {
            retrievedStoreList = [NSMutableArray arrayWithArray:storeList];
        }
        dispatch_semaphore_signal(startingThreadSemaphore);
    }];
    dispatch_semaphore_wait(startingThreadSemaphore, DISPATCH_TIME_FOREVER);
    
    NSMutableArray *storeListInDatabase = [databaseManager.selectCommands selectOnlineStoreIdsInStoreTable];
    printf("Stores in database: %lu\n", [storeListInDatabase count]);
    printf("Stores on server: %lu\n", [retrievedStoreList count]);
    printf("\n");
    [retrievedStoreList removeObjectsInArray:storeListInDatabase];
    
    return ([retrievedStoreList count] != 0) ? [retrievedStoreList copy] : nil;
}

- (void)requestAndInsertAllStoreDataWithList:(NSArray *)storeList {
    printf("[HARVESTER 🍏] Requesting %lu remaining stores...\n", [storeList count]);
    [databaseManager.updateCommands deleteOfflineStoresInDetailTable];
    [walgreensApi requestAllStoresInList:storeList];
    dispatch_semaphore_wait(startingThreadSemaphore, DISPATCH_TIME_FOREVER);
}

- (void)requestAndInsertAllProductData {
    
}

- (void)walgreensApiDidPassStore:(WalgreensAPI *)sender withData:(NSDictionary *)responseDictionary forStore:(NSString *)storeNumber {
    printf("[HARVESTER 🍏] Store #%s retrieved successfully...\n", [[storeNumber description] UTF8String]);
    printf("[HARVESTER 🍏] Inserting store #%s into database...\n", [[storeNumber description] UTF8String]);
    [databaseManager.insertCommands insertOnlineStoreWithData:responseDictionary];
}

- (void)walgreensApiDidFailStore:(WalgreensAPI *)sender forStore:(NSString *)storeNumber {
    printf("[HARVESTER 🍎] Inserting store #%s as offline into database...\n", [[storeNumber description] UTF8String]);
    [databaseManager.insertCommands insertOfflineStoreWithStoreNumber:storeNumber];
}

- (void)walgreensApiDidSendAll:(WalgreensAPI *)sender {
    printf("[HARVESTER 🍏] Requests for all stores complete.\n");
    dispatch_semaphore_signal(startingThreadSemaphore);
}

@end
