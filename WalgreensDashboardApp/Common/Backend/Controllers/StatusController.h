//
//  StatusController.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 23/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Controller.h"
#import "DatabaseManagerApp.h"
#import "DatabaseConstants.h"

static NSString *const plistStatus = @"statuses.plist";
static long const kIntervalMinutesOfDowntime = 10;

@interface StatusController : Controller <WalgreensAPIDelegate> {
    NSThread *requestThread;
}

// Temporarily saved to disk as .plist.
@property (atomic) NSMutableDictionary *storeStatuses;

- (BOOL)updateStoreStatusesForToday;
- (void)saveStoreStatuses;

// Process.
- (void)start;
- (void)stop;

@end
