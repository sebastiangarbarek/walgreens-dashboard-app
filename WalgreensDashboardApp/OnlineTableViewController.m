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
    
    int mode;
    
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
        return [[[SelectCommands alloc] init].selectStatesInStoreDetail count];
    }
    
    // Return city count
    if ([displayMode isEqualToString:@"city"]) {
        
        
        
    }
    
    
//    switch (displayMode) {
//        case StateList : {
//            // State number
//            break;
//        }
//        case CityList : {
//            // City number with specific state
//            
//            break;
//        }
//        case StoreList : {
//            // Store number with specific city
//            
//            break;
//        }
//            
//    }
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // First, display state
    // stateMode = 1
    [SelectCommands selectStateInStoreDetail];
    
    
    switch (displayMode) {
        
        case StateList : {
        
        
        }
        case CityList : {
        
        
        }
        case StoreList : {
            
            
        }
        
    
    }
    
    
    
    
    return [onlineStores count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OnlineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Online Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *city = [[onlineStores objectAtIndex:indexPath.row] objectForKey:@"city"];
    NSString *state = [[onlineStores objectAtIndex:indexPath.row] objectForKey:@"state"];
    
    if ([city length] != 0) {
        
        city = [city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        cell.onlineStoreLabel.text = [NSString stringWithFormat:@"%@, %@", city, state];
        
    } else {
        
        // Details unknow
        cell.onlineStoreLabel.text = [NSString stringWithFormat:@"Store #%@ (dayails unknow)", [[[onlineStores objectAtIndex:indexPath.row]
                                                                                                 objectForKey:@"storeNum"] stringValue]];
        
    }
    
    return cell;
    
}



@end
