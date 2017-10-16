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
    
    NSLock *nStoresRequestedLock;
    NSInteger nStoresToRequest;
    NSInteger nStoresRequested;
    
    dispatch_group_t requestGroup;
    
    Reachability *reach;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        nStoresRequestedLock = [NSLock new];
    }
    
    return self;
}

- (void)requestStoresInList:(NSArray *)storeList {
    self.thread = [NSThread currentThread];
    
    failedStores = [NSMutableArray array];
    
    nStoresToRequest = [storeList count];
    nStoresRequested = 0;
    
    requestGroup = dispatch_group_create();
    
    // To catch disconnection.
    reach = [Reachability reachabilityForInternetConnection];
    
    BOOL wasDisconnected = NO;

    for (int i = 0; i < [storeList count]; i++) {
        if ([[NSThread currentThread] isCancelled]) {
            printf("[WALGREENS API 🍏] Requests thread cancelled.\n");
            
            // Do not send anymore requests.
            break;
        }
        
        while ([reach isReachable] == NO) {
            wasDisconnected = YES;
            
            printf("[WALGREENS API 🍎] Waiting for network.\n");
            
            if ([[NSThread currentThread] isCancelled]) {
                // Do not wait to reconnect.
                break;
            }
            
            // Synchronous call.
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Not connected" object:nil];
            
            // Wait before trying again.
            [NSThread sleepForTimeInterval:1.0f];
        }
        
        if (wasDisconnected) {
            // Synchronous call.
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Connected" object:nil];
            
            wasDisconnected = NO;
        }
        
        printf("[WALGREENS API 🍏] Requesting store #%s...\n", [storeList[i] UTF8String]);
        
        // Balanced request side.
        dispatch_group_enter(requestGroup);
        
        // Request a store.
        [self requestStore:storeList[i]];
        
        // Wait before sending another request.
        [NSThread sleepForTimeInterval:0.5f];
    }
    
    // Wait until all requests leave dispatch group.
    dispatch_group_wait(requestGroup, DISPATCH_TIME_FOREVER);
    
    if ([[NSThread currentThread] isCancelled] == NO) {
        if ([failedStores count]) {
            // Recursive call.
            [self requestStoresInList:failedStores];
        }
    }
    
    // Return request thread.
    printf("[WALGREENS API 🍏] Requests thread is returning.\n");
}

- (void)requestStore:(NSString *)storeNumber {
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    [requestDictionary setValue:apiKey forKey:@"apiKey"];
    [requestDictionary setValue:affId forKey:@"affId"];
    [requestDictionary setValue:storeNumber forKey:@"storeNo"];
    [requestDictionary setValue:@"storeDtl" forKey:@"act"];
    [requestDictionary setValue:@"storeDtlJSON" forKey:@"view"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:[NetworkUtility buildRequestFrom:storeDetailServiceUrl requestData:requestDictionary]
                completionHandler:^(NSData *responseData, NSURLResponse *urlResponse, NSError *sessionError) {
                    
                    if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSInteger statusCode = [(NSHTTPURLResponse *)urlResponse statusCode];
                        
                        if (statusCode == 200) {
                            NSDictionary *responseDictionary = [self isValidResponseData:responseData storeNumber:storeNumber];
                            
                            if (responseDictionary != nil) {
                                NSString *printStatus = [[responseDictionary objectForKey:@"photoStatusCd"] description];
                                if ([printStatus isEqualToString:@"O"]) {
                                    printf("\t[#%s REQUEST 🍏] Store is online.\n", [storeNumber UTF8String]);
                                    
                                    [self.delegate walgreensApiOnlineStoreWithData:responseDictionary storeNumber:storeNumber];
                                }
                                else if ([printStatus isEqualToString:@"C"]) {
                                    printf("\t[#%s REQUEST 🍏] Store is offline.\n", [storeNumber UTF8String]);
                                    
                                    [self.delegate walgreensApiOfflineStoreWithData:responseDictionary storeNumber:storeNumber];
                                }
                                else if ([printStatus isEqualToString:@"M"]) {
                                    printf("\t[#%s REQUEST 🍏] Store is down for maintenance.\n", [storeNumber UTF8String]);
                                    
                                    [self.delegate walgreensApiScheduledMaintenanceStoreWithData:responseDictionary storeNumber:storeNumber];
                                }
                                else if ([printStatus isEqualToString:@"T"]) {
                                    printf("\t[#%s REQUEST 🍏] Store is down for unscheduled maintenance.\n", [storeNumber UTF8String]);
                                    
                                    [self.delegate walgreensApiUnscheduledMaintenanceStoreWithData:responseDictionary storeNumber:storeNumber];
                                }
                            }
                        }
                        else if (statusCode == 404) {
                            printf("\t[#%s REQUEST 🍎] Does not exist on the server.\n", [storeNumber UTF8String]);
                            
                            // Remove from database if exists.
                            [self.delegate walgreensApiStoreDoesNotExistWithStoreNumber:storeNumber];
                        }
                        else if (statusCode == 503) {
                            printf("\t[#%s REQUEST 🍎] Service is temporarily unavailable.\n", [storeNumber UTF8String]);
                            
                            // Add to failed request queue to try again later.
                            [self addToFailedRequestQueue:storeNumber];
                        }
                        else if (statusCode == 504) {
                            printf("\t[#%s REQUEST 🍎] Request took too long to send.\n", [storeNumber UTF8String]);
                            
                            // Add to failed request queue to try again later.
                            [self addToFailedRequestQueue:storeNumber];
                        }
                        else if (statusCode >= 506 && statusCode <= 512) {
                            printf("\t[#%s REQUEST 🍎] Service is down.\n", [storeNumber UTF8String]);
                            
                            // Add to failed request queue to try again later.
                            [self addToFailedRequestQueue:storeNumber];
                            
                            // Notify service is down.
                            [self.delegate walgreensApiIsDown];
                        }
                        else if (sessionError) {
                            printf("\t[#%s REQUEST 🍎] Session error.\n", [storeNumber UTF8String]);
                            
                            // Add to failed request queue to try again later.
                            [self addToFailedRequestQueue:storeNumber];
                        } else {
                            printf("\t[#%s REQUEST 🍎] Something went wrong.\n", [storeNumber UTF8String]);
                            
                            // Add to failed request queue to try again later.
                            [self addToFailedRequestQueue:storeNumber];
                        }
                    } else {
                        printf("\t[#%s REQUEST 🍎] Invalid response.\n", [storeNumber UTF8String]);
                        
                        // Add to failed request queue to try again later.
                        [self addToFailedRequestQueue:storeNumber];
                    }
                    
                    // Must leave request group.
                    dispatch_group_leave(requestGroup);
                    
                    [self incrementStoresRequested:storeNumber];
                }] resume];
}

- (NSDictionary *)isValidResponseData:(NSData *)responseData storeNumber:(NSString *)storeNumber {
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    
    if (responseDictionary == nil) {
        printf("\t[#%s REQUEST 🍎] No JSON in response.\n", [storeNumber UTF8String]);
        
        return nil;
    } else {
        NSDictionary *storeDetails = [responseDictionary objectForKey:@"store"];
        
        if (storeDetails) {
            return responseDictionary;
        } else {
            printf("\t[#%s REQUEST 🍎] No store details in response.\n", [storeNumber UTF8String]);
            
            return nil;
        }
    }
}

- (void)incrementStoresRequested:(NSString *)storeNumber {
    [nStoresRequestedLock lock];
    
    nStoresRequested++;
    printf("\t[#%s REQUEST 🍏] %.0f%% complete.\n", [storeNumber UTF8String], (100 * (double)nStoresRequested) / (double)nStoresToRequest);
    
    [nStoresRequestedLock unlock];
}

- (void)addToFailedRequestQueue:(NSString *)storeNumber {
    @synchronized (failedStores) {
        [failedStores addObject:storeNumber];
    }
}

@end
