//
//  CommonStaticTableViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 6/08/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "CommonTableViewController.h"

@interface CommonTableViewController ()

@end

@implementation CommonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Abstract Methods

- (void)reloadData {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
