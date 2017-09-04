//
//  StoreDetailsController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreDetailsController.h"

@interface StoreDetailsController () {
    
}


@end

@implementation StoreDetailsController

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Table Methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.databaseManagerApp.selectCommands storeHoursForStoreNumber:self.storeNumber])
        return 3;
    else
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1: {
            
            break;
        }
        case 2: {
            break;
        }
        default:
            return 0;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Navigation Methods -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
