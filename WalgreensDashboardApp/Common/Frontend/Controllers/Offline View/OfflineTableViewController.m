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
    
    self.date = ((OfflineViewController *)self.parentViewController).date;
    
    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    [databaseManagerApp openCreateDatabase];
    
    NSLog(@"date table view %@", self.date);
    offlineStores = [databaseManagerApp.selectCommands selectOfflineStoresInHistoryTableWithDate:self.date];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [offlineStores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OfflineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Offline Cell" forIndexPath:indexPath];
    
    NSString *city = [[offlineStores objectAtIndex:indexPath.row] objectForKey:@"city"];
    NSString *state = [[offlineStores objectAtIndex:indexPath.row] objectForKey:@"state"];
    if (city) {
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
