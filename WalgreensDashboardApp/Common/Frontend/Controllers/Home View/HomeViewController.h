//
//  HomeViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DatePickerViewController.h"

@interface HomeViewController : DatePickerViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *dateTitle;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousButton;

@property (weak, nonatomic) IBOutlet UIView *containerView;

// The current table view controller in the container view, referenced to remove.
@property (weak, nonatomic) UITableViewController *currentTableViewController;

- (void)embedInitialTableView;
- (void)embedTableView:(UITableViewController *)tableViewController;
- (void)switchBackButton;

@end
