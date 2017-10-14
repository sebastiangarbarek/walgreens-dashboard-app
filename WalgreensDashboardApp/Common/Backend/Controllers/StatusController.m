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
            // Return thread.
            dispatch_semaphore_signal(startingThreadSemaphore);
        } else if (storeList) {
            printf("[HARVESTER 🍏] Store list retrieved successfully...\n");
            
            NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documents = [directories firstObject];
            NSString *plistStatusPath = [documents stringByAppendingPathComponent:plistStatus];
            
            // Check if .plist exists.
            if ([[NSFileManager defaultManager] fileExistsAtPath:plistStatusPath]) {
                printf("[HARVESTER 🍏] Checking existing temporary data store...\n");
                self.storeStatuses = [NSMutableDictionary dictionaryWithContentsOfFile:plistStatusPath];
                // Uncomment to print temporary data state.
                // NSLog(@"%@", self.storeStatuses);
                // Check if data is not relevant to today.
                if (![[self.storeStatuses objectForKey:@"date"] isEqualToString:[DateHelper currentDate]]) {
                    printf("[HARVESTER 🍏] Temporary data is outdated...\n");
                    // Delete the .plist and create a new dictionary.
                    [[NSFileManager defaultManager] removeItemAtPath:plistStatusPath error:nil];
                    printf("[HARVESTER 🍏] Creating a new temporary data store...\n");
                    self.storeStatuses = [NSMutableDictionary new];
                    // Store today's date.
                    [self.storeStatuses setObject:[DateHelper currentDate] forKey:@"date"];
                } else {
                    printf("[HARVESTER 🍏] Using existing temporary data store.\n");
                }
            } else {
                printf("[HARVESTER 🍏] Creating new temporary data store...\n");
                // If .plist doesn't exist it will be created on app exit.
                self.storeStatuses = [NSMutableDictionary new];
                // Store today's date.
                [self.storeStatuses setObject:[DateHelper currentDate] forKey:@"date"];
            }
            
            // Get all stores that have been checked.
            NSMutableArray *stores = [NSMutableArray arrayWithArray:[self.storeStatuses allKeys]];
            // Get all non-print stores that we are not interested in.
            NSMutableArray *nonPrintStores = [databaseManager.selectCommands selectNonPrintStoreIdsInStoreTable];
            // Get all stores from the server.
            NSMutableArray *serverStores = [NSMutableArray arrayWithArray:storeList];
            // Extract the difference for the remaining print stores.
            [serverStores removeObjectsInArray:stores];
            [serverStores removeObjectsInArray:nonPrintStores];
            
            // Check if there are stores left to check.
            if ([serverStores count]) {
                // Thread management is passed to WalgreensAPI object.
                [walgreensApi requestAllStoresInList:[serverStores copy]];
                printf("[HARVESTER 🍏] A thread has returned from (requestStoreList:) completion handler.\n");
            } else {
                printf("[HARVESTER 🍏] No stores left to check today.\n");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Requests complete" object:nil];
                // Return thread.
                dispatch_semaphore_signal(startingThreadSemaphore);
            }
        } else {
            failed = YES;
            // Notify service is down.
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Not available" object:nil];
            printf("[HARVESTER 🍎] Failed to retrieve store list...\n");
            // Return thread.
            dispatch_semaphore_signal(startingThreadSemaphore);
        }
    }];
    
    printf("[HARVESTER 🍏] Waiting for threads to complete...\n");
    // Wait for dispatched threads to complete.
    dispatch_semaphore_wait(startingThreadSemaphore, DISPATCH_TIME_FOREVER);
    printf("[HARVESTER 🍏] Closing...\n");
    
    if (failed) {
        return NO;
    } else {
        return YES;
    }
}

- (void)saveStoreStatuses {
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [directories firstObject];
    NSString *plistStatusPath = [documents stringByAppendingPathComponent:plistStatus];
    [self.storeStatuses writeToFile:plistStatusPath atomically:YES];
}

- (void)walgreensApiDidPassStore:(WalgreensAPI *)sender withData:(NSDictionary *)responseDictionary forStore:(NSString *)storeNumber {
    printf("[HARVESTER 🍏] Store #%s is online.\n", [[storeNumber description] UTF8String]);
    // Insert the store and its status into the dictionary.
    [self.storeStatuses setObject:@(YES) forKey:storeNumber];
    
    // Pass number of stores checked.
    NSDictionary *data = @{@"Number of stores requested" : @([self.storeStatuses count])};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Store online" object:nil userInfo:data];
}

- (void)walgreensApiDidFailStore:(WalgreensAPI *)sender forStore:(NSString *)storeNumber {
    printf("[HARVESTER 🍎] Store #%s is offline.\n", [[storeNumber description] UTF8String]);
    // Insert the store and its status into the dictionary.
    [self.storeStatuses setObject:@(NO) forKey:storeNumber];
    // Insert the offline status into the database.
    [databaseManager.insertCommands insertOfflineHistoryWithStore:storeNumber];
    
    // Pass number of stores checked.
    NSDictionary *data = @{@"Number of stores requested" : @([self.storeStatuses count])};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Store offline" object:nil userInfo:data];
}

- (void)walgreensApiDidSendAll:(WalgreensAPI *)sender {
    printf("[HARVESTER 🍏] Requests for all stores complete.\n");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Requests complete" object:nil];
    
    // Save .plist.
    printf("[HARVESTER 🍏] Saving temporary statuses...\n");
    [self saveStoreStatuses];
    
    // Return thread.
    dispatch_semaphore_signal(startingThreadSemaphore);
}

- (void)walgreensApiIsDown {
    // Notification sent from WalgreensAPI notifies DashboardController.
    
    printf("[HARVESTER 🍎] API service is down.\n");
    // Create a new dictionary containing all stores as offline.
    
    // Save temporary statuses as .plist.
    
    // Insert all stores into the history table as offline for today.
    
    // Return thread.
    dispatch_semaphore_signal(startingThreadSemaphore);
}

@end
