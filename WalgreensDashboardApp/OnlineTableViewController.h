//
//  OnlineTableViewController.h
//  WalgreensDashboardApp
//
//  Created by Naomi Wu on 13/08/17.
//  Copyright © 2017 Naomi Wu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OnlineTableViewController : UITableViewController

@property (strong, nonatomic) NSString *date;

// The current table view controller in the container view, referenced to remove.
@property (weak, nonatomic) UITableViewController *currentTableViewController;

@property (strong, nonatomic) NSMutableArray *navigationStack;


@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
