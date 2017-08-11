//
//  HistoryTableViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonTableViewController.h"

@interface HistoryTableViewController : CommonTableViewController

@property (weak, nonatomic) IBOutlet UILabel *totalOnlineStoresLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalOfflineStoresLabel;

@end
