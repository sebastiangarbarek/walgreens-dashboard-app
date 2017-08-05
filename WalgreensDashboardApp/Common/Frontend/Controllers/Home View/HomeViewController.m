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
    
    // Remove navigation bar bottom borders.
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    self.date = [DateHelper currentDate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchTableView)
                                                 name:@"Requests complete"
                                               object:nil];
    
    [self embedTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [self checkDates];
    [self setDateForView:self.date];
    [self switchTableView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[OfflineViewController class]]) {
        [(OfflineViewController *)segue.destinationViewController setDate:self.date];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // Pass the current date to the offline view.
    if ([viewController isKindOfClass:[DatePickerViewController class]]) {
        DatePickerViewController *datePickerViewController = (DatePickerViewController *)viewController;
        datePickerViewController.date = self.date;
    }
}

- (void)embedTableView {
    UIStoryboard *updateStoryBoard = [UIStoryboard storyboardWithName:@"UpdateView" bundle:nil];
    UIStoryboard *historyStoryBoard = [UIStoryboard storyboardWithName:@"HistoryView" bundle:nil];
    
    UITableViewController *tableViewController;
    
    NSInteger numberOfStoresInDatabase = [[self.databaseManagerApp.selectCommands countPrintStoresInStoreTable] integerValue];
    NSInteger numberOfStoresInTemp = [[self.databaseManagerApp.selectCommands countStoresInTempTable] integerValue];
    
    if ((numberOfStoresInDatabase - numberOfStoresInTemp) && [self.date isEqualToString:[DateHelper currentDate]]) {
        self.navigationBar.topItem.title = @"Dashboard";
        tableViewController = [updateStoryBoard instantiateViewControllerWithIdentifier:@"Update Table View"];
    } else {
        self.navigationBar.topItem.title = @"History";
        tableViewController = [historyStoryBoard instantiateViewControllerWithIdentifier:@"History Table View"];
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
