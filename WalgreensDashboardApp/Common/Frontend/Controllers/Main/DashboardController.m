//
//  DashboardController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DashboardController.h"

@implementation DashboardController

#pragma mark - Parent Methods -

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addNotifications];
    
    self.storeTimes = [[StoreTimes alloc] init];
}

- (void)viewDidLoad {
    // Methods that update labels etc. must be called after the view has loaded.
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    /*
     Uncomment if using invalidating timer.
    if ([self.storeTimes hasUpdateHourPassed]) {
        // Open closed only update if the last recorded next update hour has passed.
        [self updateOpenClosedStores];
    } else {
        // Restart timer from invalidation.
        [self startStoreTimerWithSeconds:[self.storeTimes secondsToNextHour]];
    }
    */
}

/*
 Uncomment to force the view to update open and closed stores only when
 the user is on the screen or when the user returns and the next update hour
 has passed. Allows the view to deallocate.
- (void)viewWillDisappear:(BOOL)animated {
    // Prevent retain cycle.
    if (self.storeTimer != nil) {
        [self.storeTimer invalidate];
        self.storeTimer = nil;
    }
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"[WARNING] Dashboard received memory warning.");
}

#pragma mark - Init Methods -

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStoresOnline)
                                                 name:@"Store online"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStoresOffline)
                                                 name:@"Store offline"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestsComplete)
                                                 name:@"Requests complete"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notConnected)
                                                 name:@"Not connected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connected)
                                                 name:@"Connected"
                                               object:nil];
}

- (void)initData {
    [self updateProgressView];
    [self updateStoresOnline];
    [self updateStoresOffline];
    [self updateOpenClosedStores];
}

#pragma mark - Update Methods -

- (void)updateProgressView {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger storesInTemp = [[self.databaseManagerApp.selectCommands countStoresInTempTable] integerValue];
        NSInteger storesToRequest = [[self.databaseManagerApp.selectCommands countPrintStoresInStoreTable] integerValue];
        self.progressView.progress = (float)storesInTemp / storesToRequest;
    });
}

- (void)updateStoresOnline {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateProgressView];
        self.onlineTotal.text = [NSString stringWithFormat:@"%i",
                                 [[self.databaseManagerApp.selectCommands countOnlineStoresInTempTable] intValue]];
    });
}

- (void)updateStoresOffline {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateProgressView];
        self.offlineTotal.text = [NSString stringWithFormat:@"%i",
                                  [[self.databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:[DateHelper currentDate]] intValue]];
    });
}

- (void)requestsComplete {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.progressView removeFromSuperview];
        [self initData];
    });
}

- (void)notConnected {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
}

- (void)connected {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
}

#pragma mark - Time Methods -

- (void)updateOpenClosedStores {
    // Update the number of open and closed stores.
    NSArray *openStores = [self.storeTimes retrieveStoresWithDateTime:[DateHelper currentDateAndTime] requestOpen:YES];
    NSArray *closedStores = [self.storeTimes retrieveStoresWithDateTime:[DateHelper currentDateAndTime] requestOpen:NO];
    self.openTotal.text = [NSString stringWithFormat:@"%li", [openStores count]];
    self.closedTotal.text = [NSString stringWithFormat:@"%li", [closedStores count]];
    
    // Start a timer to update the totals again on the next hour.
    [self startStoreTimerWithSeconds:[self.storeTimes secondsToNextHour]];
}

- (void)startStoreTimerWithSeconds:(float)seconds {
    // Keep reference to manually invalidate to allow view to dealloc.
    self.storeTimer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                     target:self
                                   selector:@selector(updateOpenClosedStores)
                                   userInfo:nil
                                    repeats:NO]; // Yes, it repeats. See selector.
}

#pragma mark - Navigation Methods -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Offline History"]) {
        
    } else if ([[segue identifier] isEqualToString:@"Store Hours"]) {
        
    }
}

@end
