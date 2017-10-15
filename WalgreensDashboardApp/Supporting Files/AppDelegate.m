//
//  AppDelegate.m
//  WalgreensDashboardMock
//
//  Created by Sebastian Garbarek on 26/04/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () {
    StatusController *statusController;
    DatabaseManagerApp *databaseManagerApp;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    printf("[APP BACKGROUND] Saving temporary statuses...\n");
    [statusController saveStoreStatuses];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    printf("[APP BACKGROUND] Stopping status controller...\n");
    statusController.stop = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    printf("[APP ACTIVE] Initializing status controller...\n");
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (databaseManagerApp == nil) {
        databaseManagerApp = [[DatabaseManagerApp alloc] init];
    }
    
    if (statusController == nil) {
        statusController = [[StatusController alloc] initWithManager:databaseManagerApp];
    } else {
        [statusController start];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    printf("[APP TERMINATE] Stopping status controller...\n");
    
    statusController.stop = YES;
    
    [databaseManagerApp closeDatabase];
}

@end
