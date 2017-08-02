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
    [self.databaseManagerApp closeDatabase];
    self.databaseManagerApp = nil;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    printf("[APP] Initializing status controller...\n");
    self.databaseManagerApp = [[DatabaseManagerApp alloc] init];
    statusControllerApp = [[StatusControllerApp alloc] initWithManager:self.databaseManagerApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    printf("[APP] Stopping status controller...\n");
    [statusControllerApp stop];
    [self.databaseManagerApp closeDatabase];
    self.databaseManagerApp = nil;
}

@end
