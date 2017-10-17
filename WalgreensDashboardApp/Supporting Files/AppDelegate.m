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
    
    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    statusController = [[StatusController alloc] initWithManager:databaseManagerApp];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    printf("[APP BACKGROUND] Saving temporary list of stores requested...\n");
    
    [statusController saveTemporary];
    
    printf("[APP BACKGROUND] Stopping status controller...\n");
    
    [statusController stop];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    printf("[APP ACTIVE] Starting status controller...\n");
    
    [statusController start];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
