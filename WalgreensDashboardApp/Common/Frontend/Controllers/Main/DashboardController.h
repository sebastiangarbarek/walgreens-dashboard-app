//
//  DashboardController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "TableViewController.h"
#import "StoreTimes.h"

@interface DashboardController : TableViewController

@property StoreTimes *storeTimes;
@property NSTimer *storeTimer;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *onlineTotal;
@property (weak, nonatomic) IBOutlet UILabel *offlineTotal;
@property (weak, nonatomic) IBOutlet UILabel *openTotal;
@property (weak, nonatomic) IBOutlet UILabel *closedTotal;

@end
