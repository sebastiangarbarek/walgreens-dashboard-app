//
//  StatusController.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 23/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StatusController.h"

@interface StatusController () {
    int timesCheckedDowntime;
}

@end

@implementation StatusController

#pragma mark - Init Methods -

- (instancetype)initWithManager:(DatabaseManager *)dbManager {
    self = [super initWithManager:dbManager];
    
    if (self) {
        timesCheckedDowntime = 0;
        walgreensApi.delegate = self;
        [self startNewRequestThread];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopped)
                                                 name:@"Stopped"
                                               object:nil];
    
    return self;
}

#pragma mark - Process Methods -

- (void)start {
    // Used to restart using the same thread immediately.
    while ([self updateStoreStatusesForToday] == NO) {
        // Something went wrong.
        [NSThread sleepForTimeInterval:0.5f];
    }
    
    /*
     If the thread is in the middle of requesting and critically fails (e.g. downtime)
     we can't simply pass back a BOOL at this point notifying failure like we can before starting the requests.
     Instead, this method is returned terminating the thread that experienced the critical failure.
     while a new thread is dispatched calling this method to restart.
     */
}

- (void)stop {
    // Running loops should check if cancelled and exit at an appropriate time. I.e. when not inserting into the database.
    [walgreensApi.currentExecutingThread cancel];
}

- (void)stopped {
    // There is a chance that foreground had been called before stop finished.
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] inForeground]) {
        printf("[APP] App went into foreground before status controller stopped.\n");
        // Reboot.
        [self startNewRequestThread];
    }
}

- (void)startNewRequestThread {
    printf("[HARVESTER 🍏] Starting a new request thread...\n");
    requestThread = [[NSThread alloc] initWithTarget:self selector:@selector(start) object:nil];
    [requestThread start];
}

#pragma mark - Class Methods -

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
                    [self deleteStoreStatuses:plistStatusPath];
                    [self createNewTemporaryDataStore];
                } else {
                    printf("[HARVESTER 🍏] Using existing temporary data store.\n");
                }
            } else {
                // If .plist doesn't exist it will be created on app exit.
                [self createNewTemporaryDataStore];
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
                // Thread management is passed to WalgreensAPI object. This method is no longer in control.
                [walgreensApi requestAllStoresInList:[serverStores copy]];
                printf("[HARVESTER 🍏] A thread has returned from (requestStoreList:) completion handler.\n");
            } else {
                printf("[HARVESTER 🍏] Finished checking all stores.\n");
                
                // Uncomment to notify view controller(s)
                // [[NSNotificationCenter defaultCenter] postNotificationName:@"Requests complete" object:nil];
                
                // Return thread.
                dispatch_semaphore_signal(startingThreadSemaphore);
                
                // Delete temporary .plist statuses.
                [self deleteStoreStatuses:plistStatusPath];
                
                // The app will restart checking.
                [self startNewRequestThread];
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
    
    // To restart immediately.
    if (failed) {
        return NO;
    } else {
        return YES;
    }
}

- (void)createNewTemporaryDataStore {
    printf("[HARVESTER 🍏] Creating a new temporary data store...\n");
    self.storeStatuses = [NSMutableDictionary new];
    // Store today's date.
    [self.storeStatuses setObject:[DateHelper currentDate] forKey:@"date"];
}

- (void)deleteStoreStatuses:(NSString *)path {
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (void)saveStoreStatuses {
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [directories firstObject];
    NSString *plistStatusPath = [documents stringByAppendingPathComponent:plistStatus];
    [self.storeStatuses writeToFile:plistStatusPath atomically:YES];
}

#pragma mark - Delegate Methods -

- (void)walgreensApiDidPassStore:(WalgreensAPI *)sender withData:(NSDictionary *)responseDictionary forStore:(NSString *)storeNumber {
    printf("[HARVESTER 🍏] Store #%s is online.\n", [[storeNumber description] UTF8String]);
    
    // Check if store exists in database.
    
    
    // Check if the last downtime hasn't recorded the time service was confirmed online.
    NSDictionary *lastDownTime = [databaseManager.selectCommands selectLastDowntime];
    if (lastDownTime) {
        if ([lastDownTime objectForKey:kOnlineDateTime] == nil) {
            // Update history to show when detected online.
            [databaseManager.updateCommands updateDateTimeOnlineForStore:@"All"
                                                         offlineDateTime:[lastDownTime objectForKey:kOfflineDateTime]
                                                          onlineDateTime:[DateHelper currentDateAndTime]];
        }
    }
    
    // Check if store was offline and is now online.
    NSDictionary *lastOfflineToday = [databaseManager.selectCommands selectStoreIfHasBeenOfflineToday:storeNumber];
    if (lastOfflineToday) {
        if ([lastOfflineToday objectForKey:kOnlineDateTime] == nil) {
            // Update history to show when detected online.
            [databaseManager.updateCommands updateDateTimeOnlineForStore:storeNumber
                                                         offlineDateTime:[lastDownTime objectForKey:kOfflineDateTime]
                                                          onlineDateTime:[DateHelper currentDateAndTime]];
        }
    }
    
    // Insert the store and its status into the dictionary.
    [self.storeStatuses setObject:@(YES) forKey:storeNumber];
    
    // Pass the number of stores checked to controller(s).
    NSDictionary *data = @{@"Number of stores requested" : @([self.storeStatuses count])};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Store online" object:nil userInfo:data];
}

- (void)walgreensApiDidFailStore:(WalgreensAPI *)sender forStore:(NSString *)storeNumber {
    printf("[HARVESTER 🍎] Store #%s is offline.\n", [[storeNumber description] UTF8String]);
    
    // Insert the store and its status into the dictionary.
    [self.storeStatuses setObject:@(NO) forKey:storeNumber];
    
    // Insert the offline status into the database.
    [databaseManager.insertCommands insertOfflineHistoryWithStore:storeNumber];
    
    // Pass number of stores checked to controller(s).
    NSDictionary *data = @{@"Number of stores requested" : @([self.storeStatuses count])};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Store offline" object:nil userInfo:data];
}

- (void)walgreensApiDidSendAll:(WalgreensAPI *)sender {
    printf("[HARVESTER 🍏] Requests for all stores complete.\n");
    
    // Notify view controller(s).
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Requests complete" object:nil];
    
    // Uncomment to save .plist if restricting to one check a day.
    // printf("[HARVESTER 🍏] Saving temporary statuses...\n");
    // [self saveStoreStatuses];
    
    // Return thread.
    dispatch_semaphore_signal(startingThreadSemaphore);
    
    // Will find that all stores have been checked and immediately restart.
    [self startNewRequestThread];
}

- (void)walgreensApiIsDown {
    printf("[HARVESTER 🍎] API service is down.\n");
    
    NSDictionary *lastDownTimeToday = [databaseManager.selectCommands selectLastDowntimeToday];
    
    /*
     If the service has been detected as down for longer than a set period of time.
     Or if the service hasn't been detected as down yet.
     We must set a time limit because when a service goes down,
     it is checked to see if it has gone back up in second intervals.
     We do this to prevent adding to the history data store every second.
     */
    if (lastDownTimeToday == nil) {
        if ([lastDownTimeToday objectForKey:kOnlineDateTime] != nil) {
            // Service could have went down and up again in this session.
            printf("[HARVESTER 🍏] Service was online last checked.\n");
            timesCheckedDowntime = 0;
        }
        
        if ([DateHelper currentDateTimeIsAtLeastMinutes:kIntervalMinutesOfDowntime
                                                aheadOf:[DateHelper dateWithString:[lastDownTimeToday objectForKey:kOfflineDateTime]]
                                           timesChecked:timesCheckedDowntime
                                               interval:kIntervalMinutesOfDowntime]) {
            // Increment the number of times interval passed.
            timesCheckedDowntime++;
            
            // Notify view controller(s).
            printf("[HARVESTER 🍏] It has been at least %li minute(s) since last downtime.\n", kIntervalMinutesOfDowntime);
            printf("[HARVESTER 🍏] Notifying view controller(s)\n");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Not available" object:nil];
            
            // Insert special key that all stores were offline into history table.
            [databaseManager.insertCommands insertOfflineHistoryWithStore:@"All"];
        }
    }
    
    // Return thread.
    dispatch_semaphore_signal(startingThreadSemaphore);
    
    // Start new request thread.
    [self startNewRequestThread];
}

@end
