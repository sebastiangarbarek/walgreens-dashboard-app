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

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
