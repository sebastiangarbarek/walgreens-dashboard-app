//
//  StatusController.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 23/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Controller.h"

static NSString *const plistStatus = @"statuses.plist";

@interface StatusController : Controller <WalgreensAPIDelegate>

@property (atomic) NSMutableDictionary *storeStatuses;

- (BOOL)updateStoreStatusesForToday;
- (void)saveStoreStatuses;

@end
