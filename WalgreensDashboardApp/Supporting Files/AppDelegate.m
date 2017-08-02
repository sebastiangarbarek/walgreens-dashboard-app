//
//  AppDelegate.m
//  WalgreensDashboardMock
//
//  Created by Sebastian Garbarek on 26/04/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "AppDelegate.h"
#import "StatusControllerApp.h"

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
    // The app has approx. 5 seconds to return from this method.
    printf("[APP] Stopping status controller...\n");
    [statusControllerApp stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    printf("[APP] Initializing status controller...\n");
    [databaseManagerApp closeDatabase];
    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    statusControllerApp = [[StatusControllerApp alloc] initWithManager:databaseManagerApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    printf("[APP] Stopping status controller...\n");
    [statusControllerApp stop];
    [databaseManagerApp closeDatabase];
}

@end
