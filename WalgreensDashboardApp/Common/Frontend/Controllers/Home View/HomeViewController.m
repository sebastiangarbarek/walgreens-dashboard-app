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
                                             selector:@selector(progressViewUpdate)
                                                 name:@"Store online"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeOfflineUpdate:)
                                                 name:@"Store offline"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notConnectedUpdate)
                                                 name:@"Not connected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectedUpdate)
                                                 name:@"Connected"
                                               object:nil];
    // Remove progress view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestsCompleteUpdate)
                                                 name:@"Requests complete"
                                               object:nil];
    
    [self embedInitialTableView];
}

#pragma mark - Container View

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

- (IBAction)backButton:(id)sender {
    
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

#pragma mark - Progress View

- (void)progressViewUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger storesInTemp = [[self.databaseManagerApp.selectCommands countStoresInTempTable] integerValue];
        NSInteger storesToRequest = [[self.databaseManagerApp.selectCommands countPrintStoresInStoreTable] integerValue];
        self.requestProgressView.progress = (float)storesInTemp / storesToRequest;
        self.percentCompleteLabel.text = [NSString stringWithFormat:@"%.1f%%", (((float)storesInTemp / storesToRequest) * 100)];
    });
}

- (void)storeOfflineUpdate:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *offlineStore = notification.userInfo;
        self.notificationsLabel.textColor = [UIColor redColor];
        self.notificationsLabel.text = [NSString stringWithFormat:@"Store #%@ is offline", [offlineStore objectForKey:@"Store Number"]];
    });
}

- (void)requestsCompleteUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.progressView setHidden:YES];
    });
}

- (void)notConnectedUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.notificationsLabel.textColor = [UIColor redColor];
        self.notificationsLabel.text = @"You are not connected to the internet";
    });
}

- (void)connectedUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        self.notificationsLabel.textColor = [UIColor darkTextColor];
        self.notificationsLabel.text = @"Requesting stores...";
    });
}

@end
