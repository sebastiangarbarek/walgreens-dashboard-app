//
//  StatusControllerApp.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 1/08/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StatusControllerApp.h"
#import "DatabaseManagerApp.h"

@implementation StatusControllerApp

- (instancetype)init {
    self = [super initWithManager:[[DatabaseManagerApp alloc] init]];
    
    if (self) {
        requestThread = [[NSThread alloc] initWithTarget:self selector:@selector(start) object:nil];
        // This thread will always exit normally.
        [requestThread start];
    }
    
    return self;
}

- (void)start {
    while ([self updateStoreStatusesForToday] == NO) {
        // Notify that the app is not connected to the internet.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Not connected" object:nil];
        
        // Sleep before making another request to prevent DoS.
        [NSThread sleepForTimeInterval:0.5f];
    }
}

- (void)stop {
    // Running loops will check if cancelled and exit at an appropriate time.
    [walgreensApi.currentExecutingThread cancel];
}

@end
