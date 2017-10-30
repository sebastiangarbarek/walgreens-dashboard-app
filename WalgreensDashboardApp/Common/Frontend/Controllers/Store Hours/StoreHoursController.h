//
//  StoreHoursController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 1/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StoreTimesMapCell.h"
#import "OpenClosedCell.h"
#import "SegueDelegate.h"
#import "StoreDetailsController.h"
#import "StoreStateController.h"

@interface StoreHoursController : ViewController <UITableViewDelegate, UITableViewDataSource, SegueDelegate>

@property StoreTimes *storeTimes;
@property NSString *dateTime;
@property NSTimer *storeTimer;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
