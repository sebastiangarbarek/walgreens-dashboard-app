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

@dynamic dateTitle;
@dynamic nextButton;
@dynamic previousButton;

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDateForView:[DateHelper currentDate]];
    [self checkDates];
    
    // Remove navigation bar bottom borders.
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(embedInitialTableView)
                                                 name:@"Requests complete"
                                               object:nil];
    
    [self embedInitialTableView];
}

#pragma mark - Container

- (void)embedInitialTableView {
    [self embedTableView:[self homeTableView]];
}

- (void)embedTableView:(UITableViewController *)tableViewController {
    [self removeTableView];
    [self addChildViewController:tableViewController];
    tableViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:tableViewController.view];
    [tableViewController didMoveToParentViewController:self];
    self.currentTableViewController = tableViewController;
}

- (void)removeTableView {
    if (self.currentTableViewController != nil) {
        [self.currentTableViewController willMoveToParentViewController:nil];
        [self.currentTableViewController.view removeFromSuperview];
        [self.currentTableViewController removeFromParentViewController];
    }
}

- (UITableViewController *)homeTableView {
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
    
    return tableViewController;
}

#pragma mark - Buttons

- (void)switchBackButton {
    if ([self.backButton isEnabled]) {
        [self.backButton setEnabled:NO];
        [self.backButton setTintColor:[UIColor clearColor]];
    } else {
        [self.backButton setEnabled:YES];
        [self.backButton setTintColor:nil];
    }
}

- (IBAction)nextButton:(id)sender {
    [self setDateForView:self.nextDate];
    
    if ([self.date isEqualToString:[DateHelper currentDate]]) {
        [self removeTableView];
        [self embedTableView:[self homeTableView]];
    } else if ([self.currentTableViewController isKindOfClass:[CommonStaticTableViewController class]]) {
        [((CommonStaticTableViewController *)self.currentTableViewController) reloadData];
    }
    
    [self checkDates];
}

- (IBAction)previousButton:(id)sender {
    [self setDateForView:self.previousDate];
    
    if ([self.currentTableViewController isKindOfClass:[UpdateTableViewController class]]) {
        [self embedInitialTableView];
    } else if ([self.currentTableViewController isKindOfClass:[CommonStaticTableViewController class]]) {
        [((CommonStaticTableViewController *)self.currentTableViewController) reloadData];
    }
    
    [self checkDates];
}

@end
