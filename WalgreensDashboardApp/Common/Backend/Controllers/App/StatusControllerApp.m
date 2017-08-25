//
//  StatusControllerApp.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 1/08/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StatusControllerApp.h"
#import "DatabaseManagerApp.h"
#import "AppDelegate.h"

@implementation StatusControllerApp

- (instancetype)initWithManager:(DatabaseManager *)dbManager {
    self = [super initWithManager:dbManager];
    
    if (self) {
        requestThread = [[NSThread alloc] initWithTarget:self selector:@selector(start) object:nil];
        [requestThread start];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopped)
                                                 name:@"Stopped"
                                               object:nil];
    
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

- (void)stopped {
    // There is a chance that foreground had been called before stop finished.
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] inForeground]) {
        printf("[APP] App went into foreground before status controller stopped.\n");
        requestThread = [[NSThread alloc] initWithTarget:self selector:@selector(start) object:nil];
        [requestThread start];
    }
}

@end
