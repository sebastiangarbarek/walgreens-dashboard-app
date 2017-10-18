//
//  OfflineHistoryController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "ViewController.h"

#import "OfflineHistoryCell.h"
#import "DatePickerDelegate.h"
#import "DatePickerCell.h"
#import "DatabaseConstants.h"
#import "UIColor+AppTheme.h"

@interface OfflineHistoryController : ViewController <UITableViewDelegate, UITableViewDataSource, DatePickerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
