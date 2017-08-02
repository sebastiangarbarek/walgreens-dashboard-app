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
    [databaseManagerApp openCreateDatabase];
    
    [self configureView];
}

- (void)viewDidAppear:(BOOL)animated {
    self.date = ((HomeViewController *)self.parentViewController).date;
    [self configureView];
}

- (void)configureView {
    self.totalOnlineStoresLabel.text = [NSString stringWithFormat:@"%i",
                                        ([[databaseManagerApp.selectCommands countPrintStoresInStoreTable] intValue]
                                         - [[databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:self.date] intValue])];
    self.totalOfflineStoresLabel.text = [NSString stringWithFormat:@"%i",
                                         [[databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:self.date] intValue]];
}

@end
