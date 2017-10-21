//
//  StatusController.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 23/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

#import "Controller.h"
#import "DatabaseManager.h"
#import "DatabaseConstants.h"
#import "Reachability.h"

static NSString *const kRequestedStoresFileName = @"stores.plist";
static long const kInsertDowntimeIntoDatabaseEvery = 10;

@interface StatusController : Controller <WalgreensAPIDelegate>

@property (atomic) BOOL stopping;

// Saved to disk.
@property (atomic) NSMutableDictionary *storeStatuses;
- (void)saveTemporary;

// Requests thread.
- (void)start;
- (void)stop;

@end
