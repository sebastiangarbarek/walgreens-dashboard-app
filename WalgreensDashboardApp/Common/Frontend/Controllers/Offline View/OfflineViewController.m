//
//  OfflineViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 30/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "OfflineViewController.h"
#import "OfflineTableViewController.h"
#import "HomeViewController.h"

@interface OfflineViewController ()

@end

@implementation OfflineViewController

@dynamic nextButton;
@dynamic previousButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.delegate = self;
    
    [self embedTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    self.tabBarController.delegate = self;
    [self checkDates];
    [self setDateForView:self.date];
}

- (void)embedTableView {
    UIStoryboard *storyBoard = self.storyboard;
    OfflineTableViewController *tableViewController;
    
    tableViewController.date = self.date;
    tableViewController = [storyBoard instantiateViewControllerWithIdentifier:@"Offline Table View"];

    [self addChildViewController:tableViewController];
    tableViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:tableViewController.view];
    [tableViewController didMoveToParentViewController:self];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // Pass the current date to the home view.
    if ([viewController isKindOfClass:[HomeViewController class]]) {
        HomeViewController *homeViewController = (HomeViewController *)viewController;
        homeViewController.date = self.date;
    }
}

- (IBAction)nextButton:(id)sender {
    [self setDateForView:self.nextDate];
    UITableView *tableView = [self.containerView subviews][0];
    [self checkDates];
    [tableView reloadData];
}

- (IBAction)previousButton:(id)sender {
    [self setDateForView:self.previousDate];
    UITableView *tableView = [self.containerView subviews][0];
    [self checkDates];
    [tableView reloadData];
}

@end
