//
//  HomeViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "HomeViewController.h"
#import "UpdateTableViewController.h"
#import "HistoryTableViewController.h"

@implementation HomeViewController

@dynamic dateNavigationBar;
@dynamic dateNavigationItem;
@dynamic previousButton;
@dynamic nextButton;

@dynamic mainNavigationBar;
@dynamic mainNavigationItem;
@dynamic backButton;
@dynamic homeButton;

@dynamic containerView;

#pragma mark - Parent Methods -

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createDatabaseConnection];
    [self initializeViews];
    [self initializeNavigationStacks];
    [self addNotifications];
    [self updatePreviousAndNext];
}

- (void)createDatabaseConnection {
    self.databaseManagerApp = [[DatabaseManagerApp alloc] init];
    [self.databaseManagerApp openCreateDatabase];
}

- (void)initializeViews {
    UIViewController *initialViewController = [self appropriateHomeViewController];
    [self setHomeViewController:initialViewController withDate:[DateHelper currentDate]];
    [self setCurrentViewController:initialViewController withDate:[DateHelper currentDate]];
    [self addShadowToUpdateView];
}

- (void)addShadowToUpdateView {
    CGRect updateViewBounds = self.updateView.bounds;
    updateViewBounds.size.width = [[UIScreen mainScreen] bounds].size.width;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:updateViewBounds];
    self.updateView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.updateView.layer.shadowOffset = CGSizeMake(0.0f, -0.1f);
    self.updateView.layer.shadowOpacity = 0.25f;
    self.updateView.layer.shadowPath = shadowPath.CGPath;
}

- (void)initializeNavigationStacks {
    self.horizontalNavigationStack = [NSMutableArray new];
    self.verticalNavigationStack = [NSMutableArray new];
}

- (void)addNotifications {
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestsCompleteUpdate)
                                                 name:@"Requests complete"
                                               object:nil];
}

- (void)updatePreviousAndNext {
    
}

- (UIViewController *)appropriateHomeViewController {
    UIStoryboard *updateStoryBoard = [UIStoryboard storyboardWithName:@"UpdateView" bundle:nil];
    UIStoryboard *historyStoryBoard = [UIStoryboard storyboardWithName:@"HistoryView" bundle:nil];
    
    NSInteger numberOfStoresInDatabase = [[self.databaseManagerApp.selectCommands countPrintStoresInStoreTable] integerValue];
    NSInteger numberOfStoresInTemp = [[self.databaseManagerApp.selectCommands countStoresInTempTable] integerValue];
    
    UIViewController *viewController;
    
    if ((numberOfStoresInDatabase - numberOfStoresInTemp) && [self.currentDate isEqualToString:[DateHelper currentDate]]) {
        [self updateMainTitle:@"Dashboard"];
        viewController = [updateStoryBoard instantiateViewControllerWithIdentifier:@"Update Table View"];
    } else {
        [self updateMainTitle:@"History"];
        viewController = [historyStoryBoard instantiateViewControllerWithIdentifier:@"History Table View"];
    }
    
    return viewController;
}

- (void)checkDates {
    NSString *nextDate = [self.databaseManagerApp.selectCommands selectNextUpdateDateInHistoryTableWithDate:self.date];
    
    if (![self.date isEqualToString:[DateHelper currentDate]]) {
        if (!nextDate) {
            // Check if next date is current date.
            NSDate *laterDate = [[DateHelper dateWithString:[DateHelper currentDate]] laterDate:[DateHelper dateWithString:self.date]];
            ([laterDate isEqualToDate:[DateHelper dateWithString:[DateHelper currentDate]]]) ? [self enableButtonWithNextDate:[DateHelper currentDate]] : [self disableNextDateButton];
        } else {
            [self enableButtonWithNextDate:nextDate];
        }
    } else {
        // Equal to current day.
        [self disableNextDateButton];
    }
    
    NSString *previousDate = [self.databaseManagerApp.selectCommands selectPreviousUpdateDateInHistoryTableWithDate:self.date];
    
    if (!previousDate) {
        // Can't go forward in time so no check for current.
        [self disablePreviousDateButton];
    } else {
        [self enableButtonWithPreviousDate:previousDate];
    }
}

#pragma mark - Container View

- (void)embedInitialTableView {
    UITableViewController *homeTableView = [self homeTableView];
    [self embedTableView:homeTableView];
    [self.navigationStack push:homeTableView];
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

- (void)datePickerSwapViewWithDirection:(Transition)direction {
    UITableViewController *tableViewController;
    
    if ([self.currentTableViewController isKindOfClass:[OfflineTableViewController class]]) {
        UIStoryboard *offlineStoryBoard = [UIStoryboard storyboardWithName:@"OfflineView" bundle:nil];
        tableViewController = [offlineStoryBoard instantiateViewControllerWithIdentifier:@"Offline Table View"];
        [self animateTransitionTo:tableViewController transition:RightToLeft];
    } else if ([self.currentTableViewController isKindOfClass:[OnlineTableViewController class]]) {
        
        UIStoryboard *onlineStoryBoard = [UIStoryboard storyboardWithName:@"OnlineView" bundle:nil];
        tableViewController = [onlineStoryBoard instantiateViewControllerWithIdentifier:@"Online Table View"];
        [self animateTransitionTo:tableViewController transition:RightToLeft];
        
    } else {
        tableViewController = [self homeTableView];
        [self animateTransitionTo:tableViewController transition:direction];
    }
    
    [self.navigationStack pop];
    [self.navigationStack push:tableViewController];
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
    if ([self.navigationStack count]) {
        // Pop off current.
        [self.navigationStack pop];
        [self setDateForView:((CommonTableViewController *)[self.navigationStack peek]).date];
        [self popAnimate:[self.navigationStack pop]];
        [self checkDates];
    }
    
    if ([self.navigationStack count] == 0) {
        [self switchBackButton];
    }
}

- (IBAction)nextButton:(id)sender {
    [self setDateForView:self.nextDate];
    [self datePickerSwapViewWithDirection:RightToLeft];
    [self checkDates];
}

- (IBAction)previousButton:(id)sender {
    [self setDateForView:self.previousDate];
    [self datePickerSwapViewWithDirection:LeftToRight];
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

- (void)storeOnlineUpdate:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *onlineStore = notification.userInfo;
        self.notificationsLabel.textColor = [UIColor redColor];
        self.notificationsLabel.text = [NSString stringWithFormat:@"Store #%@ is online", [onlineStore objectForKey:@"Store Number"]];
        
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
