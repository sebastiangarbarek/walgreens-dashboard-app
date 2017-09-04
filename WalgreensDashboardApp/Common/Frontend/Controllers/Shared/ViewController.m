//
//  SharedViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createDatabaseConnection];
}

- (void)createDatabaseConnection {
    self.databaseManagerApp = [[DatabaseManagerApp alloc] init];
    [self.databaseManagerApp openCreateDatabase];
}

@end
