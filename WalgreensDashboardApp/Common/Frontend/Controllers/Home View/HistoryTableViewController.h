//
//  HistoryTableViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonTableViewController.h"
#import "DateHelper.h"
#import "WalgreensDashboardApp-Bridging-Header.h"

@interface HistoryTableViewController : CommonTableViewController

@property (weak, nonatomic) IBOutlet UILabel *totalOnlineStoresLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalOfflineStoresLabel;

@property (strong, nonatomic) NSString *currentDay;
@property (strong, nonatomic) NSMutableArray *xaixsWithDate;
@property (strong, nonatomic) NSMutableArray *dataWithDate;
@property (strong, nonatomic) NSArray *yaixsWithNumberOfStore;
@property (strong, nonatomic) NSString *nextDateForArray;
@property (strong, nonatomic) NSString *previousDateForArray;
@property (strong, nonatomic) NSString *selectedDate;

@end
