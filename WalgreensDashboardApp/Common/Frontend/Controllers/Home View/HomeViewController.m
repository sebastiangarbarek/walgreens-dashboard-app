//
//  HomeViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "HomeViewController.h"
#import "OfflineViewController.h"
#import "UpdateTableViewController.h"
#import "HistoryTableViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@dynamic nextButton;
@dynamic previousButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.date = [DateHelper currentDate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchTableView)
                                                 name:@"Requests complete"
                                               object:nil];
    
    [self embedTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    // Must reassign delegate as delegate passed between home and offline views.
    self.tabBarController.delegate = self;
    
    [self checkDates];
    [self setDateForView:self.date];
    [self switchTableView];
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
    UINavigationController *navigationController;
    
    NSInteger numberOfStoresInDatabase = [[self.databaseManagerApp.selectCommands countPrintStoresInStoreTable] integerValue];
    NSInteger numberOfStoresInTemp = [[self.databaseManagerApp.selectCommands countStoresInTempTable] integerValue];
    
    if ((numberOfStoresInDatabase - numberOfStoresInTemp) && [self.date isEqualToString:[DateHelper currentDate]]) {
        navigationController = [storyBoard instantiateViewControllerWithIdentifier:@"Home Navigation Controller"];
    } else {
        navigationController = [storyBoard instantiateViewControllerWithIdentifier:@"History Table Navigation Controller"];
    }
    
    [self addChildViewController:navigationController];
    navigationController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:navigationController.view];
    [navigationController didMoveToParentViewController:self];
    self.currentNavigationController = navigationController;
}

- (void)switchTableView {
    [self.currentNavigationController willMoveToParentViewController:nil];
    [self.currentNavigationController.view removeFromSuperview];
    [self.currentNavigationController removeFromParentViewController];
    [self embedTableView];
    [self checkDates];
}

- (IBAction)nextButton:(id)sender {
    [self setDateForView:self.nextDate];
    [self switchTableView];
}

- (IBAction)previousButton:(id)sender {
    [self setDateForView:self.previousDate];
    [self switchTableView];
}

@end
