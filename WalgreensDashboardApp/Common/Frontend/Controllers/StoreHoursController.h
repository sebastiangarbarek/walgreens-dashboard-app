//
//  StoreHoursController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 1/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleLabelCell.h"
#import "StoreTimesMapCell.h"
#import "DetailCell.h"
#import "SegueProtocol.h"
#import "StoreDetailsController.h"

@interface StoreHoursController : UIViewController <UITableViewDelegate, UITableViewDataSource, SegueProtocol>

@property StoreTimes *storeTimes;
@property NSString *dateTime;
@property NSTimer *storeTimer;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
