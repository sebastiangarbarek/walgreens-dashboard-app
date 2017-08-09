//
//  HistoryTableViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "HomeViewController.h"
#import "DatabaseManagerApp.h"

@interface HistoryTableViewController () {
    DatabaseManagerApp *databaseManagerApp;
}

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Retrieve selected date from home view controller.
    self.date = ((HomeViewController *)self.parentViewController).date;
    
    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    // Database closes itself after use.
    [databaseManagerApp openCreateDatabase];
    
    [self reloadData];
}

- (void)reloadData {
    self.date = ((HomeViewController *)self.parentViewController).date;
    
    self.totalOnlineStoresLabel.text = [NSString stringWithFormat:@"%i",
                                        ([[databaseManagerApp.selectCommands countPrintStoresInStoreTable] intValue]
                                         - [[databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:self.date] intValue])];
    self.totalOfflineStoresLabel.text = [NSString stringWithFormat:@"%i",
                                         [[databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:self.date] intValue]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        // Store status section.
        case 0: {
            switch (indexPath.row) {
                // Online row.
                case 0: {
                    break;
                }
                // Offline row.
                case 1: {
                    // Get home view.
                    HomeViewController *homeViewController = (HomeViewController *)self.parentViewController;
                    
                    // Swap container view.
                    UIStoryboard *offlineStoryBoard = [UIStoryboard storyboardWithName:@"OfflineView" bundle:nil];
                    UITableViewController *offlineTableViewController = [offlineStoryBoard instantiateViewControllerWithIdentifier:@"Offline Table View"];
                    [homeViewController animateTransitionTo:offlineTableViewController transitionDirection:Left];
                    
                    [homeViewController.navigationStack addObject:offlineTableViewController];
                    [homeViewController switchBackButton];
                    
                    break;
                }
            }
            break;
        }
    }
    // Push selected view onto navigation stack.
}

@end
