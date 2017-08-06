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
    // View should update accordingly.
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
        [self updateTotalStoresOnline];
    });
}

- (void)storeOfflineUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTotalStoresOffline];
    });
}

- (void)updateTotalStoresOnline {
    self.totalOnlineStoresLabel.text = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands countOnlineStoresInTempTable] intValue]];
}

- (void)updateTotalStoresOffline {
    self.totalOfflineStoresLabel.text = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:[DateHelper currentDate]] intValue]];
}

- (void)requestsCompleteUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Update view accordingly.
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
