//
//  OnlineTableViewController.m
//  WalgreensDashboardApp
//
//  Created by Naomi Wu on 13/08/17.
//  Copyright © 2017 Naomi Wu. All rights reserved.
//

#import "HomeViewController.h"
#import "OnlineTableViewController.h"
#import "OnlineCell.h"
#import "DatabaseManagerApp.h"
#import "DatabaseManager.h"

@interface OnlineTableViewController () {
    
    DatabaseManagerApp *databaseManagerApp;
    NSMutableArray *onlineStores;
    NSString *displayMode;
    
}

@end

@implementation OnlineTableViewController

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int mode = 0;
    switch (mode) {
        case 1 : {
            displayMode = @"state";
            break;
        }
        case 2 : {
            displayMode = @"city";
            break;
        }
        case 3 : {
            displayMode = @"storeNum";
            break;
        }
    }
    
    // Return state count
    if ([displayMode isEqualToString: @"state"]) {
        NSMutableArray *StateList = [[SelectCommands alloc] init].selectStatesInStoreDetail;
        // 54?53?
        return [StateList count];
    }
    
    // Return city number with specific state
    if ([displayMode isEqualToString:@"city"]) {
        // Specify state
        NSString *state;
        NSString *currentState;
        NSMutableArray *states = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:state];
        for (state in states) {
            if ([currentState isEqualToString:state]) {
                NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
                return [CityList count];
            }
        }
    }
    
    // Return store number with specific city
    if ([displayMode isEqualToString:@"storeNum"]) {
        // Specify city
        NSString *city;
        NSString *currentCity;
        NSMutableArray *cities = [[[SelectCommands alloc] init] selectStoresInStoreDetailWithCity:city];
        for (city in cities) {
            if ([currentCity isEqualToString:city]) {
                NSMutableArray *StoreList = [[[SelectCommands alloc] init] selectStoresInStoreDetailWithCity:[[NSString alloc] initWithFormat:@"%@", city]];
                return [StoreList count];
            }
        }
    }
    // ?
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int mode = 0;
    switch (mode) {
        case 1 : {
            displayMode = @"state";
            break;
        }
        case 2 : {
            displayMode = @"city";
            break;
        }
        case 3 : {
            displayMode = @"storeNum";
            break;
        }
    }
    
    OnlineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Online Cell" forIndexPath:indexPath];
    
    // Display state to cell
    if ([displayMode isEqualToString:@"state"]) {
        NSString *state = [[onlineStores objectAtIndex:indexPath.row] objectForKey:@"state"];
        if ([state length] != 0) {
            state = [state stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.onlineStoreLabel.text = [NSString stringWithFormat:@"Store #%@(%@)", [[[onlineStores objectAtIndex:indexPath.row]
                                                                                        objectForKey:@"storeNum"] stringValue], state];
        } else {
            // Details unknow
            cell.onlineStoreLabel.text = [NSString stringWithFormat:@"Store #%@ (details unknow)", [[[onlineStores objectAtIndex:indexPath.row]
                                                                                                     objectForKey:@"storeNum"] stringValue]];
        }
        return cell;
    }
    
    // Display cities with state to cell
    if ([displayMode isEqualToString:@"city"]) {
        NSString *state = [[SelectCommands alloc] init].selectStatesInStoreDetail[indexPath.row];
        NSString *currentState;
        NSString *city = [[onlineStores objectAtIndex:indexPath.row] objectForKey:@"city"];
        if ([currentState isEqualToString:state]) {
            if ([city length] != 0) {
                city = [city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                cell.onlineStoreLabel.text = [NSString stringWithFormat:@"Store #%@(%@ %@)", [[[onlineStores objectAtIndex:indexPath.row]
                                                                                            objectForKey:@"storeNum"] stringValue], currentState, city];
            }
            // State is null
            else {
                // Details unknown.
                cell.onlineStoreLabel.text = [NSString stringWithFormat:@"Store #%@ (details unknown)", [[[onlineStores objectAtIndex:indexPath.row]
                                                                                                          objectForKey:@"storeNum"] stringValue]];
            }
        }
        return cell;
    }
    
    // Display stores with city
    if ([displayMode isEqualToString:@"storeNum"]) {
        NSString *city = [[onlineStores objectAtIndex:indexPath.row] objectForKey:@"city"];
        
        if ([city length] != 0) {
            city = [city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.onlineStoreLabel.text = [NSString stringWithFormat:@"Store #%@(%@)", [[[onlineStores objectAtIndex:indexPath.row]
                                                                                        objectForKey:@"storeNum"] stringValue], city];
            
        } else {
            // Details unknow
            cell.onlineStoreLabel.text = [NSString stringWithFormat:@"Store #%@ (details unknow)", [[[onlineStores objectAtIndex:indexPath.row]
                                                                                                 objectForKey:@"storeNum"] stringValue]];
        }
        return cell;
    }
    
    return cell;
}



@end
