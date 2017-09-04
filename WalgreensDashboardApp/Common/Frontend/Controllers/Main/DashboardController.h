//
//  DashboardController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "TableViewController.h"

@interface DashboardController : TableViewController

@property (weak, nonatomic) IBOutlet UILabel *onlineStores;
@property (weak, nonatomic) IBOutlet UILabel *offlineStores;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
