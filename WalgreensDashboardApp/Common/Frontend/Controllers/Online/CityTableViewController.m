//
//  CityTableViewController.m
//  WalgreensDashboardApp
//
//  Created by Naomi Wu on 17/08/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "CityTableViewController.h"

@interface CityTableViewController ()

@end

@implementation CityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return city number with specific state
    return [_cityListArray count];
}



@end
