//
//  OfflineStoresController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 30/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "OfflineStoresController.h"

@interface OfflineStoresController () {
    NSArray *dates;
    NSMutableDictionary *storesToDates;
    NSInteger numberOfSectionsInTableView;
}

@end

@implementation OfflineStoresController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStoresToDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initStoresToDate {
    storesToDates = [NSMutableDictionary new];
    
    for (NSDictionary *offlineStore in self.offlineStores) {
        NSString *dateTime = [offlineStore objectForKey:kOfflineDateTime];
        NSString *date = [dateTime componentsSeparatedByString:@" "][0];
        
        NSMutableArray *offlineStoresForDate = [storesToDates objectForKey:date];
        
        if (!offlineStoresForDate) {
            NSMutableArray *newOfflineStoresForDate = [NSMutableArray new];
            [newOfflineStoresForDate addObject:offlineStore];
            [storesToDates setObject:newOfflineStoresForDate forKey:date];
        } else {
            [offlineStoresForDate addObject:offlineStore];
            [storesToDates setObject:offlineStoresForDate forKey:date];
        }
    }
    
    dates = [[storesToDates allKeys] sortedArrayUsingComparator:^NSComparisonResult(id o, id to) {
        NSString *date = (NSString *)o;
        NSString *toDate = (NSString *)to;
        
        int month = [[date substringWithRange:NSMakeRange(8, 2)] intValue];
        int toMonth = [[toDate substringWithRange:NSMakeRange(8, 2)] intValue];
        
        if (month < toMonth) {
            return NSOrderedAscending;
        } else if (month > toMonth) {
            return NSOrderedDescending;
        } else {
            int day = [[date substringWithRange:NSMakeRange(5, 2)] intValue];
            int toDay = [[toDate substringWithRange:NSMakeRange(5, 2)] intValue];
            
            if (day < toDay) {
                return NSOrderedAscending;
            } else if (day > toDay) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }
    }];
}

#pragma mark - Table Methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [storesToDates count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[storesToDates objectForKey:[dates objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [dates objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Navigation Methods -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Store Details"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        StoreDetailsController *storeDetailsController = [segue destinationViewController];
        storeDetailsController.storeNumber = [[[storesToDates objectForKey:[dates objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:kStoreNum];
    }
}

@end
