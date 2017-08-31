//
//  HomeViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 29/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WalgreensDashboardApp-Bridging-Header.h"
#import "DatePickerViewController.h"
#import "DateHelper.h"

@interface UpdateTableViewController : UITableViewController <DatePickerViewDelegate>

@property (weak, nonatomic) NSString *date;

@property (weak, nonatomic) IBOutlet UIProgressView *requestProgressView;
@property (weak, nonatomic) IBOutlet UILabel *totalOnlineStoresLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalOfflineStoresLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *notificationsCell;
@property (weak, nonatomic) IBOutlet UILabel *notificationsLabel;

@property (strong, nonatomic) NSMutableArray *xaixsWithDate;


@end
