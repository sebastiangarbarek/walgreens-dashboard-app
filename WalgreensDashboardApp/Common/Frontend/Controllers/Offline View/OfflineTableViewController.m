//
//  OfflineStoresTableViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "OfflineTableViewController.h"
#import "OfflineViewController.h"
#import "OfflineCell.h"
#import "DatabaseManagerApp.h"

@interface OfflineTableViewController () {
    DatabaseManagerApp *databaseManagerApp;
    NSMutableArray *offlineStores;
}

@end

@implementation OfflineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    [databaseManagerApp openCreateDatabase];
}

- (void)viewDidAppear:(BOOL)animated {
    self.date = ((OfflineViewController *)self.parentViewController).date;
    offlineStores = [databaseManagerApp.selectCommands selectOfflineStoresInHistoryTableWithDate:self.date];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.date = ((OfflineViewController *)self.parentViewController).date;
    offlineStores = [databaseManagerApp.selectCommands selectOfflineStoresInHistoryTableWithDate:self.date];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [offlineStores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OfflineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Offline Cell" forIndexPath:indexPath];
    
    NSString *city = [[offlineStores objectAtIndex:indexPath.row] objectForKey:@"city"];
    NSString *state = [[offlineStores objectAtIndex:indexPath.row] objectForKey:@"state"];
    
    if ([city length] != 0) {
        city = [city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        cell.storeLabel.text = [NSString stringWithFormat:@"%@, %@", city, state];
    } else {
        // Details unknown.
        cell.storeLabel.text = [[[offlineStores objectAtIndex:indexPath.row] objectForKey:@"storeNum"] stringValue];
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
