//
//  AppDelegate.m
//  WalgreensDashboardMock
//
//  Created by Sebastian Garbarek on 26/04/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () {
    StatusControllerApp *statusControllerApp;
    DatabaseManagerApp *databaseManagerApp;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    printf("[APP] Application did enter background, saving temporary statuses...\n");
    [statusControllerApp saveStoreStatuses];
    self.inForeground = NO;
    // The app has approx. 5 seconds to return from this method.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    printf("[APP] Application did enter background, stopping status controller...\n");
    // There is a chance (applicationDidBecomeActive:) is called before stop terminates.
    [statusControllerApp stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    self.inForeground = YES;
    printf("[APP] Initializing status controller...\n");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [databaseManagerApp closeDatabase];
    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    statusControllerApp = [[StatusControllerApp alloc] initWithManager:databaseManagerApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    printf("[APP] Application will terminate, stopping status controller...\n");
    [statusControllerApp stop];
    [databaseManagerApp closeDatabase];
}

@end
