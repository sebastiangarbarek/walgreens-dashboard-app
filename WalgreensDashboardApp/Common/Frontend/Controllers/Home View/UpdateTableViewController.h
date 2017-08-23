//
//  HomeViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 29/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonTableViewController.h"
#import "WalgreensDashboardApp-Bridging-Header.h"
#import "DateHelper.h"

@interface UpdateTableViewController : CommonTableViewController

@property (weak, nonatomic) IBOutlet UIProgressView *requestProgressView;
@property (weak, nonatomic) IBOutlet UILabel *totalOnlineStoresLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalOfflineStoresLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *notificationsCell;
@property (weak, nonatomic) IBOutlet UILabel *notificationsLabel;

@property (strong, nonatomic) NSMutableArray *xaixsWithDate;


@end
