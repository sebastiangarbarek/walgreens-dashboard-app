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
    [self initStoreTimes];
    [self addNotifications];
}

- (void)viewDidLoad {
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    for (int i = 0; i < 3; i++)
        NSLog(@"Dashboard received memory warning.");
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

- (void)initStoreTimes {
    self.storeTimes = [[StoreTimes alloc] init];
    [self.storeTimes loadStores];
}

- (void)initData {
    [self updateProgressView];
    [self updateStoresOnline];
    [self updateStoresOffline];
    [self updateOpenClosedStores];
}

#pragma mark - Collection Methods -

// We do not use the collection view dynamically.

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // Online, offline, open and closed.
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DashboardCountCell *dashboardCountCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Count Cell" forIndexPath:indexPath];
    
    dashboardCountCell.countLabel.adjustsFontSizeToFitWidth = YES;
    dashboardCountCell.descriptionLabel.adjustsFontSizeToFitWidth = YES;
    
    switch (indexPath.row) {
        case 0:
            dashboardCountCell.descriptionLabel.text = @"Online Stores";
            // Blue.
            dashboardCountCell.backgroundColor = [UIColor printBlue];
            break;
        case 1:
            dashboardCountCell.descriptionLabel.text = @"Offline Stores";
            // Yellow.
            dashboardCountCell.backgroundColor = [UIColor printYellow];
            break;
        case 2:
            dashboardCountCell.descriptionLabel.text = @"Open Stores";
            // Yellow.
            dashboardCountCell.backgroundColor = [UIColor printYellow];
            break;
        case 3:
            dashboardCountCell.descriptionLabel.text = @"Closed Stores";
            // Red.
            dashboardCountCell.backgroundColor = [UIColor printRed];
            break;
    }
    
    return dashboardCountCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // We want each cell's height and width to to be 50% of the available screen's height and width.
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    // No spacing between the cells.
    return 0;
}

#pragma mark - Update Methods -

- (void)updateOpenClosedStores {
    // Update the number of open and closed stores.
    NSArray *openStores = [self.storeTimes retrieveStoresWithDateTime:[DateHelper currentDateAndTime] requestOpen:YES];
    NSArray *closedStores = [self.storeTimes retrieveStoresWithDateTime:[DateHelper currentDateAndTime] requestOpen:NO];
    self.openTotal.text = [NSString stringWithFormat:@"%li", [openStores count]];
    self.closedTotal.text = [NSString stringWithFormat:@"%li", [closedStores count]];
    
    // Start a timer to update the totals again on the next hour.
    [self startStoreTimerWithSeconds:[self.storeTimes secondsToNextHour]];
}

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

#pragma mark - Helper Methods -

- (void)startStoreTimerWithSeconds:(float)seconds {
    // Keep reference to the timer to invalidate and allow the view to dealloc, if required.
    self.storeTimer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                     target:self
                                   selector:@selector(updateOpenClosedStores)
                                   userInfo:nil
                                    repeats:NO];
}

@end
