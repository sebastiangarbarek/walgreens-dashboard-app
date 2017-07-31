//
//  AppDelegate.m
//  WalgreensDashboardMock
//
//  Created by Sebastian Garbarek on 26/04/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    printf("[APP] Initializing status controller...\n");
    
    //NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(startController) object:nil];
    //[thread start];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    printf("[APP] Pausing status controller...\n");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    printf("[APP] Stopping status controller...\n");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    printf("[APP] Starting status controller...\n");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    printf("[APP] Starting status controller...\n");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    printf("[APP] Closing status controller...\n");
}

- (void)startController {
    _databaseManagerApp = [[DatabaseManagerApp alloc] init];
    _statusController = [[StatusController alloc] initWithManager:_databaseManagerApp];
    [_statusController updateStoreStatusesForToday];
}

@end
