//
//  HomeViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 29/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "UpdateTableViewController.h"
#import "OfflineViewController.h"

@interface UpdateTableViewController () {
    NSMutableArray *sectionTitles;
    NSMutableDictionary *cellTitles;
}

@end

@implementation UpdateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeOnlineUpdate)
                                                 name:@"Store online"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeOfflineUpdate)
                                                 name:@"Store offline"
                                               object:nil];
}

- (void)storeOnlineUpdate {
    [self updateProgressBar];
    [self updateTotalStoresOnline];
}

- (void)storeOfflineUpdate {
    [self updateTotalStoresOffline];
}

- (void)updateProgressBar {
    
}

- (void)updateTotalStoresOnline {
    
}

- (void)updateTotalStoresOffline {
    
}

@end
