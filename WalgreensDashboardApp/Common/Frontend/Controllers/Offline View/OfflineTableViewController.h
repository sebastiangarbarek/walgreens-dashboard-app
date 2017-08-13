//
//  OfflineStoresTableViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfflineTableViewController : UITableViewController

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSDictionary *sendDictionary;


@property (weak, nonatomic) UITableViewController *currentTableViewController;

@end
