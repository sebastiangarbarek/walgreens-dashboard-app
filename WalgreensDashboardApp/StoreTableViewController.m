//
//  StoreTableViewController.m
//  WalgreensDashboardApp
//
//  Created by Naomi Wu on 17/08/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreTableViewController.h"

@interface StoreTableViewController ()

@end

@implementation StoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
/*       // Return store number with specific city
    NSString *city;
    NSString *currentCity;
    NSMutableArray *cities = [[[SelectCommands alloc] init] selectStoresInStoreDetailWithCity:city];
    for (city in cities) {
        if ([currentCity isEqualToString:city]) {
            NSMutableArray *StoreList = [[[SelectCommands alloc] init] selectStoresInStoreDetailWithCity:[[NSString alloc] initWithFormat:@"%@", city]];
            return [StoreList count];
        }
            return [onlineStores count];
    }*/
    return 0;
}


@end
