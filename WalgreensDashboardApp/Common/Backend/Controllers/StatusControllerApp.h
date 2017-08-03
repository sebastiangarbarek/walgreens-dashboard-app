//
//  StatusControllerApp.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 1/08/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StatusController.h"

@interface StatusControllerApp : StatusController {
    NSThread *requestThread;
}

- (void)start;
- (void)stop;

@end
