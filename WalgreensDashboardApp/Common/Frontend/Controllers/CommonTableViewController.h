//
//  CommonStaticTableViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 6/08/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonTableViewController : UITableViewController

- (void)reloadData;

@property (strong, nonatomic) NSString *date;

@end
