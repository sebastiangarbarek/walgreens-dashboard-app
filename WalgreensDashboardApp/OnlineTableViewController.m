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
    
    
    return [onlineStores count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OnlineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Online Cell" forIndexPath:indexPath];
    
    // Display state
    NSString *state = [[onlineStores objectAtIndex:indexPath.row] objectForKey:@"state"];
    if ([state length] != 0) {
        
        state = [state stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        cell.onlineStoreLabel.text = [NSString stringWithFormat:@"Store #%@(%@)", [[[onlineStores objectAtIndex:indexPath.row]
                                                                                    objectForKey:@"storeNum"] stringValue], state];
        
    } else {
        
    }
    
    // Display cities with state
    if ([state isEqualToString:@""]) {
        
    }
    // State is null
    else {
        // Details unknown.
        cell.onlineStoreLabel.text = [NSString stringWithFormat:@"Store #%@ (details unknown)", [[[onlineStores objectAtIndex:indexPath.row] objectForKey:@"storeNum"] stringValue]];
    }
    NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
    
    // Display stores with city
    
    
    
    OnlineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Online Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *city = [[onlineStores objectAtIndex:indexPath.row] objectForKey:@"city"];
    NSString *state = [[onlineStores objectAtIndex:indexPath.row] objectForKey:@"state"];
    
    if ([city length] != 0) {
        
        city = [city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        cell.onlineStoreLabel.text = [NSString stringWithFormat:@"%@, %@", city, state];
        
    } else {
        
        // Details unknow
        cell.onlineStoreLabel.text = [NSString stringWithFormat:@"Store #%@ (details unknow)", [[[onlineStores objectAtIndex:indexPath.row]
                                                                                                 objectForKey:@"storeNum"] stringValue]];
        
    }
    
    return cell;
    
}



@end
