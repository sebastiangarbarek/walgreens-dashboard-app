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

- (instancetype)initWithManager:(DatabaseManager *)dbManager {
    self = [super initWithManager:dbManager];
    
    if (self) {
        requestThread = [[NSThread alloc] initWithTarget:self selector:@selector(start) object:nil];
        [requestThread start];
    }
    
    return self;
}

- (void)start {
    while ([self updateStoreStatusesForToday] == NO) {
        // Something went wrong.
        [NSThread sleepForTimeInterval:0.5f];
    }
}

- (void)stop {
    // Running loops should check if cancelled and exit at an appropriate time.
    [walgreensApi.currentExecutingThread cancel];
}

@end
