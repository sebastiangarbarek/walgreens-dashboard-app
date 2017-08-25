//
//  StatusController.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 23/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StatusController.h"

@implementation StatusController

- (instancetype)init {
    self = [super init];
    if (self) {
        walgreensApi.delegate = self;
    }
    return self;
}

- (instancetype)initWithManager:(DatabaseManager *)dbManager {
    self = [super initWithManager:dbManager];
    if (self) {
        walgreensApi.delegate = self;
    }
    return self;
}

- (BOOL)updateStoreStatusesForToday {
    printf("[HARVESTER 🍏] Requesting store list...\n");
    
    __block BOOL failed;
    [NetworkUtility requestStoreList:^(NSArray *storeList, NSError *sessionError) {
        if (sessionError) {
            if (sessionError.code == NSURLErrorNotConnectedToInternet) {
                printf("[HARVESTER 🍎] Not connected to the internet.\n");
                failed = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Not connected" object:nil];
            }
            dispatch_semaphore_signal(startingThreadSemaphore);
        } else if (storeList) {
            printf("[HARVESTER 🍏] Store list retrieved successfully...\n");
            
            // Extract the difference for remaining stores.
            NSMutableArray *retrievedStoreList = [NSMutableArray arrayWithArray:storeList];
            NSMutableArray *storeListInDatabase = [databaseManager.selectCommands selectStoreIdsInTempTable];
            NSMutableArray *nonPrintStores = [databaseManager.selectCommands selectNonPrintStoreIdsInStoreTable];
            [retrievedStoreList removeObjectsInArray:storeListInDatabase];
            [retrievedStoreList removeObjectsInArray:nonPrintStores];
            
            if ([retrievedStoreList count]) {
                [databaseManager.updateCommands deletePastTempStatuses];
                
                // Thread management is passed to WalgreensAPI object.
                [walgreensApi requestAllStoresInList:[retrievedStoreList copy]];
                
                printf("[HARVESTER 🍏] A thread has returned from (requestStoreList:) completion handler.\n");
            } else {
                printf("[HARVESTER 🍏] No stores left to check today.\n");
                dispatch_semaphore_signal(startingThreadSemaphore);
            }
        } else {
            failed = YES;
            printf("[HARVESTER 🍎] Failed to retrieve store list...\n");
            dispatch_semaphore_signal(startingThreadSemaphore);
        }
    }];
    
    printf("[HARVESTER 🍏] Waiting for threads to complete...\n");
    dispatch_semaphore_wait(startingThreadSemaphore, DISPATCH_TIME_FOREVER);
    
    if (failed) {
        return NO;
    } else {
        return YES;
    }
}

- (void)walgreensApiDidPassStore:(WalgreensAPI *)sender withData:(NSDictionary *)responseDictionary forStore:(NSString *)storeNumber {
    printf("[HARVESTER 🍏] Store #%s is online.\n", [[storeNumber description] UTF8String]);
    [databaseManager.insertCommands insertTempStatusWithStore:storeNumber online:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Store online" object:nil];
}

- (void)walgreensApiDidFailStore:(WalgreensAPI *)sender forStore:(NSString *)storeNumber {
    printf("[HARVESTER 🍎] Store #%s is offline.\n", [[storeNumber description] UTF8String]);
    [databaseManager.insertCommands insertTempStatusWithStore:storeNumber online:NO];
    [databaseManager.insertCommands insertOfflineHistoryWithStore:storeNumber];
    
    NSMutableDictionary *offlineStore = [NSMutableDictionary new];
    [offlineStore setObject:storeNumber forKey:@"Store Number"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Store offline" object:nil userInfo:offlineStore];
}

- (void)walgreensApiDidSendAll:(WalgreensAPI *)sender {
    printf("[HARVESTER 🍏] Requests for all stores complete.\n");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Requests complete" object:nil];
    dispatch_semaphore_signal(startingThreadSemaphore);
}

@end
