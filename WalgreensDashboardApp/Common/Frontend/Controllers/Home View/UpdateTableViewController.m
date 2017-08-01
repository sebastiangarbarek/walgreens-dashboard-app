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

@interface UpdateTableViewController () {
    DatabaseManagerApp *databaseManagerApp;
    NSInteger totalStoresToRequest;
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
    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    totalStoresToRequest = [[databaseManagerApp.selectCommands countPrintStoresInStoreTable] integerValue];
}

- (void)configureView {
    self.totalOnlineStoresLabel.text = @"0";
    self.totalOfflineStoresLabel.text = @"0";
}

- (void)storeOnlineUpdate {
    [self updateProgressBar];
    [self updateTotalStoresOnline];
}

- (void)storeOfflineUpdate {
    [self updateTotalStoresOffline];
}

- (void)updateProgressBar {
    self.requestProgressView.progress
     = (float)[[databaseManagerApp.selectCommands countStoresInTempTable] integerValue] / [[databaseManagerApp.selectCommands countPrintStoresInStoreTable] integerValue];
}

- (void)updateTotalStoresOnline {
    self.totalOnlineStoresLabel.text
    = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands countOnlineStoresInTempTable] intValue]];
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
