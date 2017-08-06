//
//  HomeViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 29/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "UpdateTableViewController.h"
#import "HomeViewController.h"
#import "OfflineViewController.h"
#import "DatabaseManagerApp.h"

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
                                             selector:@selector(connectedUpdate)
                                                 name:@"Connected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestsCompleteUpdate)
                                                 name:@"Requests complete"
                                               object:nil];
    
    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    [databaseManagerApp openCreateDatabase];
    
    [self configureView];
}

- (void)configureView {
    self.totalOnlineStoresLabel.text = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands countOnlineStoresInTempTable] intValue]];
    self.totalOfflineStoresLabel.text = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:[DateHelper currentDate]] intValue]];
}

- (void)storeOnlineUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateProgressBar];
        [self updateTotalStoresOnline];
        [self.tableView reloadData];
    });
}

- (void)storeOfflineUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTotalStoresOffline];
        // Additional notification of store offline can be called here.
        [self.tableView reloadData];
    });
}

- (void)updateProgressBar {
    NSInteger storesInTemp = [[databaseManagerApp.selectCommands countStoresInTempTable] integerValue];
    NSInteger storesToRequest = [[databaseManagerApp.selectCommands countPrintStoresInStoreTable] integerValue];
    self.requestProgressView.progress = (float)storesInTemp / storesToRequest;
}

- (void)updateTotalStoresOnline {
    self.totalOnlineStoresLabel.text = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands countOnlineStoresInTempTable] intValue]];
}

- (void)updateTotalStoresOffline {
    self.totalOfflineStoresLabel.text = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:[DateHelper currentDate]] intValue]];
}

- (void)notConnectedUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.notificationsLabel.textColor = [UIColor redColor];
        self.notificationsLabel.text = @"You are not connected to the internet";
        self.notificationsCell.hidden = NO;
        [self.tableView reloadData];
    });
}

- (void)connectedUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        self.notificationsLabel.textColor = [UIColor darkTextColor];
        self.notificationsLabel.text = @"";
        self.notificationsCell.hidden = YES;
        [self.tableView reloadData];
    });
}

- (void)requestsCompleteUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        // Store status section
        case 0: {
            switch (indexPath.row) {
                // Online row
                case 0: {
                    break;
                }
                // Offline row
                case 1: {
                    // Get home view.
                    HomeViewController *homeViewController = (HomeViewController *)self.parentViewController;
                    
                    // Enable back button on home view.
                    [homeViewController switchBackButton];
                    [homeViewController.backButton setAction:@selector(backHome)];
                    
                    // Swap container view.
                    UIStoryboard *offlineStoryBoard = [UIStoryboard storyboardWithName:@"OfflineView" bundle:nil];
                    UITableViewController *offlineViewController = [offlineStoryBoard instantiateViewControllerWithIdentifier:@"Offline Table View"];
                    [homeViewController embedTableView:offlineViewController];
                    
                    break;
                }
            }
            break;
        }
        // Store hours section
        case 1: {
            break;
        }
    }
}

- (void)backHome {
    // Get home view.
    HomeViewController *homeViewController = (HomeViewController *)self.parentViewController.parentViewController;
    
    // Disable back button on home view.
    [homeViewController switchBackButton];
    [homeViewController.backButton setAction:@selector(backHome)];
    
    // Swap container view.
    [homeViewController embedInitialTableView];
}

@end
