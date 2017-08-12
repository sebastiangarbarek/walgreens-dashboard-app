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
#import "ChartsView.h"

@interface HistoryTableViewController () {
    DatabaseManagerApp *databaseManagerApp;
    ChartsView *chartView;
    
}
@property (strong, nonatomic) IBOutlet LineChartView *graphForOnlineStores;
@property (strong, nonatomic) IBOutlet LineChartView *graphForOfflineStores;

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Retrieve selected date from home view controller.
    self.date = ((HomeViewController *)self.parentViewController).date;
    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    
    // Database closes itself after use.
    [databaseManagerApp openCreateDatabase];
    [self setUpChart];

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
    }
    // Push selected view onto navigation stack.
}

- (void)setUpChart{
    _xaixsWithDate = [[NSMutableArray alloc] init];
    chartView =[[ChartsView alloc] init];
    
    [chartView setSelfDate:self.date];
    
    _xaixsWithDate = [chartView setXAixsArray:_xaixsWithDate];
    
    NSMutableArray *onlineStoreNumberData = [chartView getStoreNumberFor:_xaixsWithDate :@"Online"];
    NSMutableArray *offlineStoreNumberData = [chartView getStoreNumberFor:_xaixsWithDate :@"Offline"];
    
    _graphForOnlineStores.data = [chartView setDataForStores:_xaixsWithDate:onlineStoreNumberData: @"Online" :_graphForOnlineStores];
    _graphForOfflineStores.data = [chartView setDataForStores:_xaixsWithDate :offlineStoreNumberData: @"Offline" :_graphForOfflineStores];
    
}

@end
