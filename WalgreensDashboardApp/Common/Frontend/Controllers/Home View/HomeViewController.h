//
//  HomeViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DatePickerViewController.h"

@interface HomeViewController : DatePickerViewController <UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousButton;

// The current table view controller in the container view, referenced to remove.
@property (weak, nonatomic) UITableViewController *currentTableViewController;

@end
