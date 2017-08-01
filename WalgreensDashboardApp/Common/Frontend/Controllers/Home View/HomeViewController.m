//
//  HomeViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "HomeViewController.h"
#import "OfflineViewController.h"
#import "DateHelper.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.date = [DateHelper currentDate];
    
    self.tabBarController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestsComplete)
                                                 name:@"Requests complete"
                                               object:nil];
    
    [self embedTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.title = self.date;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // Pass the current date to the offline view.
    if ([viewController isKindOfClass:[OfflineViewController class]]) {
        OfflineViewController *offlineViewController = (OfflineViewController *)viewController;
        offlineViewController.date = self.date;
    }
}

- (void)embedTableView {
    UIStoryboard *storyBoard = self.storyboard;
    UITableViewController *tableViewController;
    
    if (/* DISABLES CODE */ (1) /* Requests not complete */) {
        tableViewController = [storyBoard instantiateViewControllerWithIdentifier:@"Update Table View"];
    } else {
        tableViewController = [storyBoard instantiateViewControllerWithIdentifier:@"History Table View"];
    }
    
    [self addChildViewController:tableViewController];
    [self.containerView addSubview:tableViewController.view];
    [tableViewController didMoveToParentViewController:self];
    self.currentTableViewController = tableViewController;
}

- (void)requestsComplete {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self.currentTableViewController willMoveToParentViewController:nil];
    [self.currentTableViewController.view removeFromSuperview];
    [self.currentTableViewController removeFromParentViewController];
    
    [self embedTableView];
}

- (IBAction)nextButton:(id)sender {
    
}

- (IBAction)previousButton:(id)sender {
    
}

@end
