//
//  TableViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "TableViewController.h"

@implementation TableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createDatabaseConnection];
}

- (void)createDatabaseConnection {
    self.databaseManager = [[DatabaseManager alloc] init];
    [self.databaseManager openCreateDatabase];
}

@end
