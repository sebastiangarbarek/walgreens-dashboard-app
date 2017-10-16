//
//  StatusController.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 23/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StatusController.h"

@interface StatusController () {
    NSString *requestedStoresFilePath;
    
    int nDowntime;
    
    BOOL wasDisconnected;
}

@end

@implementation StatusController

#pragma mark - Init Methods -

- (instancetype)initWithManager:(DatabaseManager *)manager {
    self = [super initWithManager:manager];
    
    if (self) {
        nDowntime = 0;
        
        walgreensApi.delegate = self;
        
        NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documents = [directories firstObject];
        
        requestedStoresFilePath = [documents stringByAppendingPathComponent:kRequestedStoresFileName];
    }
    
    return self;
}

#pragma mark - Process Methods -

- (void)start {    
    printf("[STATUS] Starting a new request thread...\n");
    
    // Do not need to keep a reference to this thread.
    [[[NSThread alloc] initWithTarget:self selector:@selector(request) object:nil] start];
}

- (void)request {
    while (!self.stopping) {
        // Returns on store list failure, on completion of requests or cancelling.
        [self requestStores];
        
        // Wait before starting requests again.
        [NSThread sleepForTimeInterval:1.0f];
    }
    
    printf("[STATUS] Stopped.\n");
    
    // Must be called after exiting loop.
    self.stopping = NO;
}

- (void)stop {
    // Must be called before calling cancel.
    self.stopping = YES;
    
    // Because stopping needs to be set for return.
    [walgreensApi.thread cancel];
}

#pragma mark - Class Methods -

- (void)requestStores {
    [NetworkUtility requestStoreList:^(NSArray *storeList, BOOL notConnected) {
        if (notConnected) {
            wasDisconnected = YES;
            
            // Notify view controller(s).
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Not connected" object:nil];
            
            // Try again.
            dispatch_semaphore_signal(startSemaphore);
        }
        else if (storeList) {
            if (wasDisconnected) {
                // Notify view controller(s).
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Connected" object:nil];
                
                wasDisconnected = NO;
            }
            
            NSArray *remainingStores = [self validateTemporary:storeList];
            [walgreensApi requestStoresInList:remainingStores];
        }
        else {
            // Try again.
            dispatch_semaphore_signal(startSemaphore);
        }
    }];
    
    dispatch_semaphore_wait(startSemaphore, DISPATCH_TIME_FOREVER);
}

- (NSArray *)validateTemporary:(NSArray *)storeList {
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [directories firstObject];
    NSString *plistStatusPath = [documents stringByAppendingPathComponent:kRequestedStoresFileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistStatusPath]) {
        printf("[STATUS] Checking temporary list of stores requested...\n");
        
        self.storeStatuses = [NSMutableDictionary dictionaryWithContentsOfFile:plistStatusPath];
        
        // Uncomment to print temporary list.
        // NSLog(@"%@", self.storeStatuses);
        
        if ([[self.storeStatuses objectForKey:@"date"] isEqualToString:[DateHelper currentDate]] == NO) {
            printf("[STATUS] List of requested stores is outdated.\n");
            
            [self deleteTemporary];
            [self newTemporary];
            
            return storeList;
        }
    } else {
        [self newTemporary];
        
        return storeList;
    }
    
    return [self getRemainingStores:storeList];
}

- (void)newTemporary {
    printf("[STATUS] Creating a new temporary list of requested stores...\n");
    
    self.storeStatuses = [NSMutableDictionary new];
    
    // Store today's date.
    [self.storeStatuses setObject:[DateHelper currentDate] forKey:@"date"];
}

- (void)deleteTemporary {
    [[NSFileManager defaultManager] removeItemAtPath:requestedStoresFilePath error:nil];
}

- (void)saveTemporary {
    [self.storeStatuses writeToFile:requestedStoresFilePath atomically:YES];
}

- (NSArray *)getRemainingStores:(NSArray *)storeList {
    // Get all stores that have been checked.
    NSMutableArray *stores = [NSMutableArray arrayWithArray:[self.storeStatuses allKeys]];
    
    // Get all non-print stores that we are not interested in.
    NSMutableArray *nonPrintStores = [databaseManager.selectCommands selectNonPrintStoreIdsInStoreTable];
    
    // Get all stores from the server.
    NSMutableArray *serverStores = [NSMutableArray arrayWithArray:storeList];
    
    // Extract the difference for the remaining print stores.
    [serverStores removeObjectsInArray:stores];
    [serverStores removeObjectsInArray:nonPrintStores];
    
    // If there are no remaining stores.
    if ([serverStores count] == 0) {
        [self deleteTemporary];
        [self newTemporary];
        
        return storeList;
    }
    
    return serverStores;
}

- (void)addTemporary:(NSString *)storeNumber status:(BOOL)status {
    // Insert the store and its status into the dictionary.
    [self.storeStatuses setObject:@(status) forKey:storeNumber];
}

- (void)insertOfflineStore:(NSString *)storeNumber printStatus:(NSString *)printStatus {
    [databaseManager.insertCommands insertOfflineHistoryWithStore:storeNumber status:printStatus];
}

- (void)insertStoreIntoDatabaseIfNotExists:(NSString *)storeNumber responseDictionary:(NSDictionary *)responseDictionary {
    if ([databaseManager.selectCommands storeExists:storeNumber] == NO) {
        printf("[STATUS] Store #%s does not exist in the database.\n", [[storeNumber description] UTF8String]);
        
        [databaseManager.insertCommands insertOnlineStoreWithData:responseDictionary];
    }
}

- (void)updateStatusOfServerIfWasDown {
    NSDictionary *lastDownTime = [databaseManager.selectCommands selectLastDowntime];
    
    if (lastDownTime) {
        if ([lastDownTime objectForKey:kOnlineDateTime] == nil) {
            NSString *offlineDateTime = [lastDownTime objectForKey:kOfflineDateTime];
            
            if (offlineDateTime) {
                printf("[STATUS 🍏] Server is back online.\n");
                
                // Update history to show when detected online.
                [databaseManager.updateCommands updateDateTimeOnlineForStore:@"All"
                                                             offlineDateTime:[lastDownTime objectForKey:kOfflineDateTime]
                                                              onlineDateTime:[DateHelper currentDateAndTime]];
            }
        }
    }
}

- (void)updateStoreStatusIfWasOffline:(NSString *)storeNumber {
    NSDictionary *lastOfflineToday = [databaseManager.selectCommands selectStoreIfHasBeenOfflineToday:storeNumber];
    
    if (lastOfflineToday) {
        if ([lastOfflineToday objectForKey:kOnlineDateTime] == nil) {
            printf("[STATUS 🍏] Store #%s is back online.\n", [[storeNumber description] UTF8String]);
            
            // Update history to show when detected online.
            [databaseManager.updateCommands updateDateTimeOnlineForStore:storeNumber
                                                         offlineDateTime:[lastOfflineToday objectForKey:kOfflineDateTime]
                                                          onlineDateTime:[DateHelper currentDateAndTime]];
        }
    }
}

- (void)checkDowntime {
    NSDictionary *lastDownTimeToday = [databaseManager.selectCommands selectLastDowntimeToday];
    
    if (lastDownTimeToday == nil) {
        nDowntime = 0;
        
        [self insertDowntime];
    } else {
        if ([lastDownTimeToday objectForKey:kOnlineDateTime] != nil) {
            printf("[STATUS] Server was online last checked.\n");
            
            nDowntime = 0;
            
            [self insertDowntime];
        } else {
            if ([lastDownTimeToday objectForKey:kOfflineDateTime]) {
                if ([DateHelper currentDateTimeIsAtLeastMinutes:kInsertDowntimeIntoDatabaseEvery
                                                        aheadOf:[DateHelper dateWithString:[lastDownTimeToday objectForKey:kOfflineDateTime]]
                                                   timesChecked:nDowntime]) {
                    nDowntime++;
                    
                    printf("[STATUS] Server has been down for %li minute(s).\n", kInsertDowntimeIntoDatabaseEvery * nDowntime);
                    
                    [self insertDowntime];
                }
            }
        }
    }
}

- (void)insertDowntime {
    printf("[STATUS] Inserting downtime into database...\n");
    [databaseManager.insertCommands insertOfflineHistoryWithStore:@"All" status:nil];
}

#pragma mark - Delegate Methods -

- (void)walgreensApiOnlineStoreWithData:(NSDictionary *)responseDictionary storeNumber:(NSString *)storeNumber {
    [self insertStoreIntoDatabaseIfNotExists:storeNumber responseDictionary:responseDictionary];
    
    // Needs work.
    // [self updateStatusOfServerIfWasDown];
    
    // Needs work.
    // [self updateStoreStatusIfWasOffline:storeNumber];
    
    [self addTemporary:storeNumber status:YES];
    
    NSDictionary *data = @{@"Number of stores requested" : @([self.storeStatuses count])};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Store online" object:nil userInfo:data];
}

- (void)walgreensApiOfflineStoreWithData:(NSDictionary *)responseDictionary storeNumber:(NSString *)storeNumber {
    [self offline:responseDictionary storeNumber:storeNumber];
    
    NSDictionary *data = @{@"Number of stores requested" : @([self.storeStatuses count])};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Store offline" object:nil userInfo:data];
}

- (void)walgreensApiScheduledMaintenanceStoreWithData:(NSDictionary *)responseDictionary storeNumber:(NSString *)storeNumber {
    [self offline:responseDictionary storeNumber:storeNumber];
    
    NSDictionary *data = @{@"Number of stores requested" : @([self.storeStatuses count])};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Store scheduled maintenance" object:nil userInfo:data];
}

- (void)walgreensApiUnscheduledMaintenanceStoreWithData:(NSDictionary *)responseDictionary storeNumber:(NSString *)storeNumber {
    [self offline:responseDictionary storeNumber:storeNumber];
    
    NSDictionary *data = @{@"Number of stores requested" : @([self.storeStatuses count])};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Store unscheduled maintenance" object:nil userInfo:data];
}

- (void)walgreensApiStoreDoesNotExistWithStoreNumber:(NSString *)storeNumber {
    if ([databaseManager.selectCommands storeExists:storeNumber] == YES) {
        printf("[STATUS] Discontinued store #%s exists in database.\n", [[storeNumber description] UTF8String]);
        printf("[STATUS] Removing store #%s from database.\n", [[storeNumber description] UTF8String]);
        [databaseManager.updateCommands deleteStoreFromStoreDetailTable:storeNumber];
    }
    
    // Store list and store detail on server might not be in sync.
    [self addTemporary:storeNumber status:NO];
}

- (void)walgreensApiIsDown {
    // Needs work.
    // [self checkDowntime];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Not available" object:nil];
}

- (void)offline:(NSDictionary *)responseDictionary storeNumber:(NSString *)storeNumber {
    [self insertStoreIntoDatabaseIfNotExists:storeNumber responseDictionary:responseDictionary];
    
    // Needs work.
    // [self updateStatusOfServerIfWasDown];
    
    [self addTemporary:storeNumber status:NO];
    [self insertOfflineStore:storeNumber printStatus:[responseDictionary objectForKey:kPhotoStatus]];
}

@end
