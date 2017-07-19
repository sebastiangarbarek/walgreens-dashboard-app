//
//  TemporaryData.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 9/05/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TemporaryData.h"

@implementation TemporaryData

static TemporaryData *_sharedInstance;

/*
 Temporary data uses the singleton pattern for controllers to access
 and modify its contained data which is shared across the controllers that
 retrieve the shared instance.
 */
+ (TemporaryData *)sharedInstance {
    if (!_sharedInstance) {
        _sharedInstance = [[TemporaryData alloc] init];
    }
    
    return _sharedInstance;
}

@end
