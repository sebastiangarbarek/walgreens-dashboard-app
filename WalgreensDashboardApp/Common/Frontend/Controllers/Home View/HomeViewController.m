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
    
    self.tabBarController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchTableView)
                                                 name:@"Requests complete"
                                               object:nil];
    
    [self embedTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"DATE HOME %@", self.date);
    [self checkDates];
    [self setDateForView:self.date];
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
    
    NSInteger numberOfStoresInDatabase = [[self.databaseManagerApp.selectCommands countPrintStoresInStoreTable] integerValue];
    NSInteger numberOfStoresInTemp = [[self.databaseManagerApp.selectCommands countStoresInTempTable] integerValue];
    
    if ((numberOfStoresInDatabase - numberOfStoresInTemp) && [self.date isEqualToString:[DateHelper currentDate]]) {
        tableViewController = [storyBoard instantiateViewControllerWithIdentifier:@"Update Table View"];
    } else {
        tableViewController = [storyBoard instantiateViewControllerWithIdentifier:@"History Table View"];
    }
    
    [self addChildViewController:tableViewController];
    tableViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:tableViewController.view];
    [tableViewController didMoveToParentViewController:self];
    self.currentTableViewController = tableViewController;
}

- (void)switchTableView {
    [self.currentTableViewController willMoveToParentViewController:nil];
    [self.currentTableViewController.view removeFromSuperview];
    [self.currentTableViewController removeFromParentViewController];
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
