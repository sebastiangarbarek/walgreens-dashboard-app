//
//  WalgreensAPI.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 24/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "WalgreensAPI.h"

@implementation WalgreensAPI {
    NSMutableArray *failedStores;
    NSMutableDictionary *failedStoreCounts;
    NSLock *failedStoreCountsLock;
    NSLock *failedStoresListLock;
    NSInteger totalStoresToRequest;
    NSInteger totalStoresRequested;
    dispatch_semaphore_t startingThreadSemaphore;
    dispatch_group_t dispatchGroup;
    Reachability *reach;
}

@synthesize delegate;

- (instancetype)initWithSemaphore:(dispatch_semaphore_t)semaphore {
    self = [super init];
    if (self) {
        failedStoreCounts = [NSMutableDictionary dictionary];
        failedStoreCountsLock = [NSLock new];
        failedStoresListLock = [NSLock new];
        startingThreadSemaphore = semaphore;
    }
    return self;
}

- (void)requestAllStoresInList:(NSArray *)storeList {
    failedStores = [NSMutableArray array];
    totalStoresToRequest = [storeList count];
    totalStoresRequested = 0;
    dispatchGroup = dispatch_group_create();
    reach = [Reachability reachabilityForInternetConnection];
    
    // Storing a reference to the current executing thread gives control to the source.
    self.currentExecutingThread = [NSThread currentThread];
    
    for (int i = 0; i < [storeList count]; i++) {
        // Exit before making another request or inserting into the database.
        if ([[NSThread currentThread] isCancelled]) {
            printf("[HARVESTER 🍏] A thread for (requestAllStoresInList:) has been cancelled and will exit.\n");
            
            // Will signal starting thread to return.
            dispatch_semaphore_signal(startingThreadSemaphore);
            
            // There is a chance foreground is called before stopping.
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Stopped" object:nil];
            
            return;
        }
        
        // While not connected to the internet and not cancelled.
        while (![reach isReachable] && !([[NSThread currentThread] isCancelled])) {
            printf("[HARVESTER 🍎] Not connected to the internet...\n");
            // Notify not connected to the internet.
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Not connected" object:nil];
            [NSThread sleepForTimeInterval:0.5f];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Connected" object:nil];
        
        dispatch_group_enter(dispatchGroup);
        printf("[HARVESTER 🍏] Requesting store #%s...\n", [storeList[i] UTF8String]);
        [self requestStore:storeList[i]];
        
        [NSThread sleepForTimeInterval:0.5f];
    }
    
    dispatch_group_notify(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if ([failedStores count]) {
            printf("[HARVESTER 🍏] Starting a new background thread for (requestAllStoresInList:).\n");
            [self requestAllStoresInList:failedStores];
        } else {
            [self.delegate walgreensApiDidSendAll:self];
        }
    });
    
    printf("[HARVESTER 🍏] A thread has returned from (requestAllStoresInList:).\n");
}

- (void)requestStore:(NSString *)storeNumber {
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    [requestDictionary setValue:apiKey forKey:@"apiKey"];
    [requestDictionary setValue:affId forKey:@"affId"];
    [requestDictionary setValue:storeNumber forKey:@"storeNo"];
    [requestDictionary setValue:@"storeDtl" forKey:@"act"];
    [requestDictionary setValue:@"storeDtlJSON" forKey:@"view"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:[NetworkUtility buildRequestFrom:storeDetailServiceUrl andRequestData:requestDictionary]
                completionHandler:^(NSData *responseData, NSURLResponse *urlResponse, NSError *sessionError) {
                    if ([NetworkUtility did404:urlResponse]) {
                        [self.delegate walgreensApiDidFailStore:self forStore:storeNumber];
                    } else if ([NetworkUtility validResponse:urlResponse withError:sessionError andData:responseData]) {
                        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                        NSDictionary *storeDetails = [responseDictionary objectForKey:@"store"];
                        if ([storeDetails valueForKey:@"storeNum"]) {
                            [self.delegate walgreensApiDidPassStore:self withData:responseDictionary forStore:storeNumber];
                        } else {
                            // Service is temporarily unavailable.
                            if ([responseDictionary valueForKey:@"fault"]) {
                                // Service being down is registered as all stores offline.
                                [self.delegate walgreensApiDidFailStore:self forStore:storeNumber];
                            } else {
                                // Give store a chance.
                                [self failStore:storeNumber];
                            }
                        }
                    } else {
                        [self failStore:storeNumber];
                    }
                    dispatch_group_leave(dispatchGroup);
                    totalStoresRequested++;
                    printf("[HARVESTER 🍏] %.0f%% complete.\n", [NetworkUtility percentCompleteWithCount:totalStoresRequested andTotal:totalStoresToRequest]);
                    printf("[HARVESTER 🍏] %lu store(s) in failed request queue.\n", (unsigned long)[failedStores count]);
                }] resume];
}

- (void)failStore:(NSString *)storeNumber {
    printf("[HARVESTER 🍎] Failed to retrieve store #%s...\n", [[storeNumber description] UTF8String]);
    
    [failedStoresListLock lock];
    [failedStoreCountsLock lock];
    
    NSInteger storeFailureCount = [[failedStoreCounts objectForKey:storeNumber] integerValue];
    if (storeFailureCount) {
        if (storeFailureCount > 3) {
            printf("[HARVESTER 🍎] Store #%s has failed more than 3 times...\n", [[storeNumber description] UTF8String]);
            [failedStoreCounts removeObjectForKey:storeNumber];
            [failedStores removeObject:storeNumber];
            [self.delegate walgreensApiDidFailStore:self forStore:storeNumber];
        } else {
            [failedStoreCounts setValue:[NSNumber numberWithInteger:storeFailureCount + 1] forKey:storeNumber];
        }
    } else {
        [failedStoreCounts setValue:[NSNumber numberWithInteger:1] forKey:storeNumber];
        [failedStores addObject:storeNumber];
    }
    
    [failedStoresListLock unlock];
    [failedStoreCountsLock unlock];
}

@end
