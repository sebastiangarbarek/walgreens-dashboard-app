//
//  DashboardController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DashboardController.h"

@interface DashboardController () {
    BOOL failureState, userOnScreen;
    NSMutableArray<DashboardCountCellData *> *cellCollection;
    NSTimer *notificationTimer;
}

@end

@implementation DashboardController

#pragma mark - Parent Methods -

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initStoreTimes];
    [self addNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureViewOnAppearWithThemeColor:[UIColor printicularBlue]];
    
    // Store went offline off screen and the user has not seen the notification.
    if (!self.offlineNotificationView.isHidden) {
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideOfflineNotificationFromTimer) userInfo:nil repeats:NO];
    }
    
    userOnScreen = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    userOnScreen = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    for (int i = 0; i < 3; i++)
        NSLog(@"Dashboard received memory warning.");
}

#pragma mark - Init Methods -

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStoresOnline:)
                                                 name:@"Store online"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStoresOffline:)
                                                 name:@"Store offline"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notConnected)
                                                 name:@"Not connected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notAvailable)
                                                 name:@"Not available"
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
    // Assume worst case scenario, as needs to be checked first.
    failureState = YES;
    
    // Get the numbers.
    int numberOfPrintStores = [[self.databaseManager.selectCommands countPrintStoresInStoreTable] intValue];
    int offline = [[self.databaseManager.selectCommands countOfflineInHistoryTableWithDateTime:[DateHelper currentDateAndTime]] intValue];
    int online = numberOfPrintStores - offline;
    NSArray *openStores = [self.storeTimes retrieveStoresWithDateTime:[DateHelper currentDateAndTime] requestOpen:YES];
    NSArray *closedStores = [self.storeTimes retrieveStoresWithDateTime:[DateHelper currentDateAndTime] requestOpen:NO];
    NSUInteger open = [openStores count];
    NSUInteger closed = [closedStores count];
    
    // Assign cell data.
    cellCollection = [NSMutableArray new];
    
    DashboardCountCellData *onlineCell = [DashboardCountCellData new];
    DashboardCountCellData *offlineCell = [DashboardCountCellData new];
    DashboardCountCellData *openCell = [DashboardCountCellData new];
    DashboardCountCellData *closedCell = [DashboardCountCellData new];
    
    onlineCell.backgroundColor = [UIColor printicularBlue];
    onlineCell.title = @"Stores Online";
    onlineCell.count = [NSNumberFormatter localizedStringFromNumber:@(online)
                                                        numberStyle:NSNumberFormatterDecimalStyle];
    
    offlineCell.backgroundColor = [UIColor printicularYellow];
    offlineCell.title = @"Stores Offline";
    offlineCell.count = [NSNumberFormatter localizedStringFromNumber:@(offline)
                                                         numberStyle:NSNumberFormatterDecimalStyle];
    
    openCell.backgroundColor = [UIColor printicularYellow];
    openCell.title = @"Stores Open";
    openCell.count = [NSNumberFormatter localizedStringFromNumber:@(open)
                                                      numberStyle:NSNumberFormatterDecimalStyle];
    
    closedCell.backgroundColor = [UIColor printicularRed];
    closedCell.title = @"Stores Closed";
    closedCell.count = [NSNumberFormatter localizedStringFromNumber:@(closed)
                                                        numberStyle:NSNumberFormatterDecimalStyle];
    
    [cellCollection addObject:onlineCell];
    [cellCollection addObject:offlineCell];
    [cellCollection addObject:openCell];
    [cellCollection addObject:closedCell];
}

#pragma mark - Collection Methods -

// The collection view won't be used dynamically.

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // Online, offline, open and closed.
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DashboardCountCell *dashboardCountCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Count Cell" forIndexPath:indexPath];
    
    // Configure.
    dashboardCountCell.countLabel.adjustsFontSizeToFitWidth = YES;
    dashboardCountCell.descriptionLabel.adjustsFontSizeToFitWidth = YES;
    
    // Assign.
    dashboardCountCell.backgroundColor = [cellCollection objectAtIndex:indexPath.row].backgroundColor;
    dashboardCountCell.descriptionLabel.text = [cellCollection objectAtIndex:indexPath.row].title;
    dashboardCountCell.countLabel.text = [cellCollection objectAtIndex:indexPath.row].count;
    
    return dashboardCountCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // We want each of the 4 cell's height and width to to be 50% of the available screen's height and width.
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    float navigationBarHeight = self.navigationController.navigationBar.bounds.size.height;
    float progressViewHeight = self.progressView.bounds.size.height;
    float tabBarHeight = self.tabBarController.tabBar.bounds.size.height;
    float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float availableHeight = screen.size.height - navigationBarHeight - progressViewHeight - tabBarHeight - statusBarHeight;
    
    return CGSizeMake(screen.size.width / 2, availableHeight / 2);
}

#pragma mark - Update Methods -

- (void)updateOpenClosedStores {
    // Update the number of open and closed stores.
    NSArray *openStores = [self.storeTimes retrieveStoresWithDateTime:[DateHelper currentDateAndTime] requestOpen:YES];
    NSArray *closedStores = [self.storeTimes retrieveStoresWithDateTime:[DateHelper currentDateAndTime] requestOpen:NO];
    NSUInteger open = [openStores count];
    NSUInteger closed = [closedStores count];
    
    // Update cell data.
    [cellCollection objectAtIndex:2].count = [NSNumberFormatter localizedStringFromNumber:@(open)
                                                                              numberStyle:NSNumberFormatterDecimalStyle];
    [cellCollection objectAtIndex:3].count = [NSNumberFormatter localizedStringFromNumber:@(closed)
                                                                              numberStyle:NSNumberFormatterDecimalStyle];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Uncomment to disable flashing.
        //[UIView setAnimationsEnabled:NO];
        NSMutableArray *indexPaths = [NSMutableArray new];
        NSIndexPath *openIndexPath = [NSIndexPath indexPathForItem:2 inSection:0];
        NSIndexPath *closedIndexPath = [NSIndexPath indexPathForItem:3 inSection:0];
        [indexPaths addObject:openIndexPath];
        [indexPaths addObject:closedIndexPath];
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
        //[UIView setAnimationsEnabled:animationsEnabled];
    });
    
    // Start a timer to update the totals again on the next hour.
    [self startStoreTimerWithSeconds:[self.storeTimes secondsToNextHour]];
}

- (void)updateProgressView:(NSInteger)numberOfStoresRequested {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger numberOfStoresToRequest = [[self.databaseManager.selectCommands countPrintStoresInStoreTable] integerValue];
        self.progressView.progress = (float) numberOfStoresRequested / numberOfStoresToRequest;
    });
}

- (void)updateStoresOnline:(NSNotification *) notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL wasInFailureState = failureState;
        
        // Store(s) are being retrieved successfully.
        failureState = NO;
        
        if (![notificationTimer isValid] && !(self.notificationView.isHidden)) {
            // If the service is not available notification is showing, hide it.
            self.notificationView.hidden = YES;
            // This will not be called if showing a timed checking stores notification however.
        }
        
        if (wasInFailureState) {
            [self presentTimedNotification:@"Checking Stores" backgroundColor:[UIColor blackColor]];
            // The service was in a failure state before this, correctly show that stores are back online.
            [self updateOnlineOfflineCells];
        }
        
        NSDictionary *data = notification.userInfo;
        // Update the progress view.
        [self updateProgressView:[[data objectForKey:@"Number of stores requested"] integerValue]];
    });
}

- (void)updateStoresOffline:(NSNotification *) notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *data = notification.userInfo;
        // Update the progress view.
        [self updateProgressView:[[data objectForKey:@"Number of stores requested"] integerValue]];
        // Update the number of online and offline stores.
        [self updateOnlineOfflineCells];
        // If user is on the screen display a timed notification.
        if (userOnScreen) {
            [self presentOfflineNotificationForStore:[data objectForKey:@"Store number"]];
            [self startOfflineNotificationTimer];
        } else {
            // Will be timed when the user returns to the screen.
            [self presentOfflineNotificationForStore:[data objectForKey:@"Store number"]];
        }
    });
}

- (void)notConnected {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        // Guaranteed to be hidden after a store is retrieved successfully.
        [self.notificationView setHidden:NO];
        
        self.notificationLabel.text = @"Waiting For Network 📡";
        
        failureState = YES;
    });
}

- (void)notAvailable {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Guaranteed to be hidden after a store is retrieved successfully.
        [self.notificationView setHidden:NO];
        
        self.notificationLabel.text = @"Service is Down 🚨";
        
        failureState = YES;
        [self updateOnlineOfflineCells];
    });
}

- (void)connected {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
}

#pragma mark - Notification View Methods -

- (void)presentTimedNotification:(NSString *)notification backgroundColor:(UIColor *)color {
    self.notificationView.backgroundColor = color;
    self.notificationLabel.text = notification;
    self.notificationView.hidden = NO;
    // Display notification for 3 seconds.
    notificationTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideNotificationFromTimer) userInfo:nil repeats:NO];
}

- (void)hideNotificationFromTimer {
    self.notificationView.hidden = YES;
    notificationTimer = nil;
}

- (void)hideOfflineNotificationFromTimer {
    self.offlineNotificationView.hidden = YES;
}

- (void)presentOfflineNotificationForStore:(NSString *)storeNumber {
    NSDictionary *cityState = [self.databaseManager.selectCommands selectCityStateForStore:storeNumber];
    
    if ([[cityState objectForKey:kCity] length] != 0 && [[cityState objectForKey:kState] length] != 0) {
        self.offlineNotificationView.hidden = NO;
        self.offlineNotificationLabel.text = [NSString stringWithFormat:@"%@, %@ Is Offline", [cityState objectForKey:kCity], [cityState objectForKey:kState]];
    }
    
    // Don't show notification if details unknown.
}

- (void)startOfflineNotificationTimer {
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hideOfflineNotificationFromTimer) userInfo:nil repeats:NO];
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

- (void)updateOnlineOfflineCells {
    int online, offline;
    int numberOfPrintStores = [[self.databaseManager.selectCommands countPrintStoresInStoreTable] intValue];
    if (failureState) {
        online = 0;
        offline = numberOfPrintStores;
    } else {
        offline = [[self.databaseManager.selectCommands countOfflineInHistoryTableWithDateTime:[DateHelper currentDateAndTime]] intValue];
        online = numberOfPrintStores - offline;
    }

    // Update cell data.
    [cellCollection objectAtIndex:0].count = [NSNumberFormatter localizedStringFromNumber:@(online)
                                                                              numberStyle:NSNumberFormatterDecimalStyle];
    [cellCollection objectAtIndex:1].count = [NSNumberFormatter localizedStringFromNumber:@(offline)
                                                                              numberStyle:NSNumberFormatterDecimalStyle];
    
    [UIView setAnimationsEnabled:NO];
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSIndexPath *onlineIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    NSIndexPath *offlineIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
    [indexPaths addObject:onlineIndexPath];
    [indexPaths addObject:offlineIndexPath];
    [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    [UIView setAnimationsEnabled:YES];
}

@end
