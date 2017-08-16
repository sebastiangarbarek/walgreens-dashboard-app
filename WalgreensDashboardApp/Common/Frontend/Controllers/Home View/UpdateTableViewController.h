//
//  HomeViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 29/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonTableViewController.h"

@interface UpdateTableViewController : CommonTableViewController

@property (weak, nonatomic) IBOutlet UIProgressView *requestProgressView;
@property (weak, nonatomic) IBOutlet UILabel *totalOnlineStoresLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalOfflineStoresLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *notificationsCell;
@property (weak, nonatomic) IBOutlet UILabel *notificationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalOpenStoresLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalClosedStoresLabel;

@end
