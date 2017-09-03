//
//  HomeViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 29/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "UpdateTableViewController.h"
#import "HomeViewController.h"
#import "DatabaseManagerApp.h"
#import "ChartsView.h"


@interface UpdateTableViewController () {
    DatabaseManagerApp *databaseManagerApp;
    ChartsView *chartView;
    BOOL completed;
}

@end

@implementation UpdateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Retrieve selected date from home view controller.
    self.date = ((HomeViewController *)self.parentViewController).date;
    

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
    
    [self setUpChart];
    
    [self reloadData];
}

- (void)reloadData {
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
        completed = YES;
        // Reload tableView data
        [self.tableView reloadData];
        [self setUpChart];
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        // Store status section
        case 0: {
            switch (indexPath.row) {
                // Online row
                case 0: {
                    
                    // Get home view.
                    HomeViewController *homeViewController = (HomeViewController *)self.parentViewController;
                    
                    // Swap container view.
                    UIStoryboard *onlineStoryBoard = [UIStoryboard storyboardWithName:@"OnlineView" bundle:nil];
                    UITableViewController *onlineTableViewController = [onlineStoryBoard instantiateViewControllerWithIdentifier:@"Online Table View"];
                    [homeViewController animateTransitionTo:onlineTableViewController transition:Push];
                    
                    [homeViewController switchBackButton];
                    
                    break;
                    
                }
                // Offline row
                case 2: {
                    // Get home view.
                    HomeViewController *homeViewController = (HomeViewController *)self.parentViewController;
                    
                    // Swap container view.
                    UIStoryboard *offlineStoryBoard = [UIStoryboard storyboardWithName:@"OfflineView" bundle:nil];
                    UITableViewController *offlineTableViewController = [offlineStoryBoard instantiateViewControllerWithIdentifier:@"Offline Table View"];
                    [homeViewController animateTransitionTo:offlineTableViewController transition:Push];
                    
                    [homeViewController switchBackButton];
                    
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
    // Push selected view onto navigation stack.
}

//Set the height of cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(completed){
        if(indexPath.row ==1){
            return 200;
        }
        if(indexPath.row == 3){
            return 200;
        }
        return 45;
    }else{
        if(indexPath.row ==1){
            return 0;
        }
        if(indexPath.row == 3){
            return 0;
        }
        return 45;
    }
}

- (void)setUpChart{
    if(completed){
        _xaixsWithDate = [[NSMutableArray alloc] init];
        chartView =[[ChartsView alloc] init];
    
        [chartView setSelfDate:self.date];
    
        _xaixsWithDate = [chartView setXAixsArray:_xaixsWithDate];
    
        NSMutableArray *onlineStoreNumberData = [chartView getStoreNumberFor:_xaixsWithDate :@"Online"];
        NSMutableArray *offlineStoreNumberData = [chartView getStoreNumberFor:_xaixsWithDate :@"Offline"];
    
        _graphForOnlineStores.data = [chartView setDataForStores:_xaixsWithDate:onlineStoreNumberData: @"Online" :_graphForOnlineStores];
        _graphForOfflineStores.data = [chartView setDataForStores:_xaixsWithDate :offlineStoreNumberData: @"Offline" :_graphForOfflineStores];
    }
    
}

#pragma mark - Delegate Methods -

- (UIViewController *)datePickerViewControllerDidRequestNewInstance:(DatePickerViewController *)datePickerViewController {
    UIViewController *instance;
    // Unique case where view can change. Other class implementations are not so complicated.
    HomeViewController *homeViewController = (HomeViewController *)self.parentViewController;
    instance = [homeViewController appropriateHomeViewController];
    
    // Pass date so that data loads.
    instance.date = self.date;
    
    return instance;
}

@end
