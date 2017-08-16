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
        if ([state isEqualToString:@"AK"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"AL"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"AR"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"AZ"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"CA"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"CO"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"CT"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"DC"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"DE"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"FL"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"GA"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"HI"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"IA"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"ID"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"IL"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"IN"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"KS"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"KY"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"LA"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"MA"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"MD"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"ME"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"MI"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"MN"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"MO"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"MS"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"MT"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"NC"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"ND"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"NE"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"NH"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"NJ"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"NM"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"NV"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"NY"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"OH"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"OK"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"OR"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"PA"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"PR"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"RI"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"SC"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"SD"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"TN"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"TX"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"UT"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"VA"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"VI"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"VT"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"WA"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"WI"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"WV"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        if ([state isEqualToString:@"WY"]) {
            NSMutableArray *CityList = [[[SelectCommands alloc] init] selectCitiesInStoreDetailWithState:[[NSString alloc] initWithFormat:@"%@", state]];
            return [CityList count];
        }
        else {
            return 0;
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
