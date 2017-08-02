//
//  HomeViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 29/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "UpdateTableViewController.h"
#import "OfflineViewController.h"
#import "DatabaseManagerApp.h"

#import "AppDelegate.h"

@interface UpdateTableViewController () {
    DatabaseManagerApp *databaseManagerApp;
}

@end

@implementation UpdateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeOnlineUpdate)
                                                 name:@"Store online"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeOfflineUpdate)
                                                 name:@"Store offline"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notConnectedUpdate)
                                                 name:@"Not connected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notConnectedUpdate)
                                                 name:@"Connected"
                                               object:nil];
    
    [self configureView];
    
    databaseManagerApp = [(AppDelegate *)[[UIApplication sharedApplication] delegate] databaseManagerApp];
}

- (void)configureView {
    self.totalOnlineStoresLabel.text = @"0";
    self.totalOfflineStoresLabel.text = @"0";
}

- (void)storeOnlineUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateProgressBar];
        [self updateTotalStoresOnline];
        [self.tableView reloadData];
    });
}

- (void)storeOfflineUpdate {
    [self updateTotalStoresOffline];
}

- (void)updateProgressBar {
    NSInteger storesInTemp = [[databaseManagerApp.selectCommands countStoresInTempTable] integerValue];
    NSInteger storesToRequest = [[databaseManagerApp.selectCommands countPrintStoresInStoreTable] integerValue];
    if (!storesInTemp) {
        printf("[APP] (countStoresInTempTable:) returned nil.\n");
    } else {
        self.requestProgressView.progress = (float)storesInTemp / storesToRequest;
    }
}

- (void)updateTotalStoresOnline {
    NSInteger storesOnlineInTemp = [[databaseManagerApp.selectCommands countOnlineStoresInTempTable] integerValue];
    if (!storesOnlineInTemp) {
        printf("[APP] (countOnlineStoresInTempTable:) returned nil.\n");
    } else {
        self.totalOnlineStoresLabel.text = [NSString stringWithFormat:@"%li", (long)storesOnlineInTemp];
    }
}

- (void)updateTotalStoresOffline {
    self.totalOfflineStoresLabel.text
    = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:[DateHelper dateWithString:[DateHelper currentDate] ]] intValue]];
}

- (void)notConnectedUpdate {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.notificationsLabel.textColor = [UIColor redColor];
    self.notificationsLabel.text = @"You are not connected to the internet";
    self.notificationsCell.hidden = NO;
}

- (void)connectedUpdate {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.notificationsLabel.textColor = [UIColor darkTextColor];
    self.notificationsLabel.text = @"";
    self.notificationsCell.hidden = YES;
}

@end
