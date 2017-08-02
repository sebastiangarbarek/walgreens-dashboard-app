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
#import "DateHelper.h"
#import "DatabaseManagerApp.h"

@interface HomeViewController () {
    DatabaseManagerApp *databaseManagerApp;
    BOOL isNextDate;
    BOOL isPrevDate;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.date = [DateHelper currentDate];
    
    self.tabBarController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchTableView)
                                                 name:@"Requests complete"
                                               object:nil];
    
    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    [databaseManagerApp openCreateDatabase];
    
    [self checkDates];
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
    
    NSInteger numberOfStoresInDatabase = [[databaseManagerApp.selectCommands countPrintStoresInStoreTable] integerValue];
    NSInteger numberOfStoresInTemp = [[databaseManagerApp.selectCommands countStoresInTempTable] integerValue];
    
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

- (void)checkDates {
    NSString *nextDate = [databaseManagerApp.selectCommands selectNextUpdateDateInHistoryTableWithDate:self.date];
    
    if (![self.date isEqualToString:[DateHelper currentDate]]) {
        if (!nextDate) {
            // Check if next date is current date.
            NSDate *laterDate = [[DateHelper dateWithString:[DateHelper currentDate]] laterDate:[DateHelper dateWithString:self.date]];
            ([laterDate isEqualToDate:[DateHelper dateWithString:[DateHelper currentDate]]]) ? [self enableButtonWithNextDate:[DateHelper currentDate]] : [self disableNextDateButton];
        } else {
            [self enableButtonWithNextDate:nextDate];
        }
    } else {
        [self disableNextDateButton];
    }

    NSString *previousDate = [databaseManagerApp.selectCommands selectPreviousUpdateDateInHistoryTableWithDate:self.date];
    
    if (!previousDate) {
        // Can't go forward in time so no check for current.
        [self disablePreviousDateButton];
    } else {
        [self enableButtonWithPreviousDate:previousDate];
    }
}

- (void)setDateForView:(NSString *)date {
    self.date = date;
    self.navigationItem.title = self.date;
}

- (void)enableButtonWithNextDate:(NSString *)nextDate {
    self.nextButton.enabled = YES;
    self.nextDate = nextDate;
}

- (void)enableButtonWithPreviousDate:(NSString *)previousDate {
    self.previousButton.enabled = YES;
    self.previousDate = previousDate;
}

- (void)disableNextDateButton {
    self.nextButton.enabled = NO;
    self.nextDate = nil;
}

- (void)disablePreviousDateButton {
    self.previousButton.enabled = NO;
    self.previousDate = nil;
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
