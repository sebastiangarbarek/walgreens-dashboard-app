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
    // Set the navigation bar tint color to white.
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0]];
    // Set the navigation bar text color to Walgreens red.
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:229.0/255.0 green:25.0/255.0 blue:55.0/255.0 alpha:1.0]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
