//
//  OfflineStoresTableViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "HomeViewController.h"
#import "OfflineTableViewController.h"
#import "OfflineCell.h"
#import "DatabaseManagerApp.h"
#import "DetailViewController.h"


@interface OfflineTableViewController () {
    DatabaseManagerApp *databaseManagerApp;
    NSMutableArray *offlineStores;
}

@end

@implementation OfflineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    // Database closes itself after use.
    [databaseManagerApp openCreateDatabase];
}

- (void)viewDidAppear:(BOOL)animated {
    self.date = ((HomeViewController *)self.parentViewController).date;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.date = ((HomeViewController *)self.parentViewController).date;
    offlineStores = [databaseManagerApp.selectCommands selectOfflineStoresInHistoryTableWithDate:self.date];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [offlineStores count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Show Store Detail"]) {
        DetailViewController *storeDetailViewController = [segue destinationViewController];
        NSIndexPath *selectedPath = [[self tableView] indexPathForSelectedRow];
        _sendArray = [offlineStores objectAtIndex:selectedPath.row];
        storeDetailViewController.recivedArray = _sendArray;
        NSLog(@"send");
    }
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
        cell.storeLabel.text = [NSString stringWithFormat:@"Store #%@ (details unknown)", [[[offlineStores objectAtIndex:indexPath.row] objectForKey:@"storeNum"] stringValue]];
    }
    
    return cell;
}

@end
