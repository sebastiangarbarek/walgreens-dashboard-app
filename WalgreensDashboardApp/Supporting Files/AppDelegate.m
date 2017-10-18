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
    
    //[self randomOfflineHistory];
    
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

- (void)randomOfflineHistory {
    [databaseManagerApp openCreateDatabase];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSArray *printStores = [databaseManagerApp.selectCommands selectAllPrintStoreIds];
    
    for (int i = 1; i <= 9; i++) {
        [components setYear:2017];
        [components setMonth:i];
        
        NSDate *date = [calendar dateFromComponents:components];
        NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
        
        for (int j = 1; j <= range.length; j++) {
            NSInteger lowerBound = 0;
            NSInteger upperBound = 150;
            NSInteger rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
            
            for (int k = 0; k < rndValue; k++) {
                lowerBound = 0;
                upperBound = 3;
                rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
                
                NSString *status;
                switch (rndValue) {
                    case 0:
                        status = @"M";
                        break;
                    case 1:
                        status = @"C";
                        break;
                    case 2:
                        status = @"T";
                        break;
                    default:
                        status = @"C";
                        break;
                }
                
                lowerBound = 0;
                upperBound = [printStores count];
                rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
                
                [databaseManagerApp.insertCommands insertOfflineHistoryWithStore:[printStores objectAtIndex:rndValue] status:status day:@(j) month:@(i) year:@(2017)];
            }
        }
    }
}

@end
