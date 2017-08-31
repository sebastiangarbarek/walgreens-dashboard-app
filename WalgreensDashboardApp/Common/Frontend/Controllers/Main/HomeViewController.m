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

/*
 For future portability in design improvements,
 @dynamic should be removed and replaced with U.I.
 being implemented programmatically from DatePickerViewController.
 */

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
    [self createDatabaseConnection];
    [self initializeViews];
    [self addNotifications];
    [self updatePreviousAndNext];
    
    // DatePickerViewController awakeFromNib should be called last.
    [super awakeFromNib];
}

#pragma mark - Initialization Methods -

- (void)createDatabaseConnection {
    self.databaseManagerApp = [[DatabaseManagerApp alloc] init];
    [self.databaseManagerApp openCreateDatabase];
}

- (void)initializeViews {
    UIViewController *initialViewController = [self appropriateHomeViewController];
    [self setHomeViewController:initialViewController withDate:[DateHelper currentDate]];
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

#pragma mark - Controller Methods -

- (void)updatePreviousAndNext {
    // Note history table does not store current date if updating.
    NSString *nextDate = [self.databaseManagerApp.selectCommands
                          selectNextUpdateDateInHistoryTableWithDate:self.currentDate];
    
    if (![self.currentDate isEqualToString:[DateHelper currentDate]]) {
        // Current date is not equal to today.
        if (!nextDate) {
            // Database didn't return a next date.
            NSDate *laterDate = [[DateHelper dateWithString:[DateHelper currentDate]] laterDate:[DateHelper dateWithString:self.currentDate]];
            if ([laterDate isEqualToDate:[DateHelper dateWithString:[DateHelper currentDate]]]) {
                // Next date is today's date that is currently updating.
                [self setNextViewController:[self appropriateHomeViewController] withDate:self.homeDate];
            }
        } else {
            // There is a next date that is not today's date.
            [self setNextViewController:[self appopriateNextPreviousViewController] withDate:nextDate];
        }
    } else {
        // Current date is today's date so there is no next.
    }
    
    NSString *previousDate = [self.databaseManagerApp.selectCommands selectPreviousUpdateDateInHistoryTableWithDate:self.currentDate];
    
    if (previousDate) {
        [self setPreviousViewController:[self appopriateNextPreviousViewController] withDate:previousDate];
    } else {
        // No need to check further.
    }
}

/*!Creates a new home screen.
 The home/dashboard screen is different depending if the current day is updating or not.
 * \returns The correct home screen.
 */
- (UIViewController *)appropriateHomeViewController {
    UIStoryboard *updateStoryBoard = [UIStoryboard storyboardWithName:@"UpdateView" bundle:nil];
    UIStoryboard *historyStoryBoard = [UIStoryboard storyboardWithName:@"HistoryView" bundle:nil];
    
    NSInteger numberOfStoresInDatabase = [[self.databaseManagerApp.selectCommands countPrintStoresInStoreTable] integerValue];
    NSInteger numberOfStoresInTemp = [[self.databaseManagerApp.selectCommands countStoresInTempTable] integerValue];
    
    UIViewController *viewController;
    
    if ((numberOfStoresInDatabase - numberOfStoresInTemp) && [self.currentDate isEqualToString:[DateHelper currentDate]]) {
        viewController = [updateStoryBoard instantiateViewControllerWithIdentifier:@"Update Table View"];
    } else {
        viewController = [historyStoryBoard instantiateViewControllerWithIdentifier:@"History Table View"];
    }
    
    [self updateMainTitle:@"Dashboard"];
    
    return viewController;
}

/*!Creates a new next/previous screen.
 The next/previous screen is different depending on which class is currently being displayed.
 * \returns The correct next/previous screen.
 */
- (UIViewController *)appopriateNextPreviousViewController {
    if ([self.currentViewController isKindOfClass:[DatePickerView class]]) {
        return [((DatePickerView *)self.currentViewController) newInstance];
    }
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Must extend DatePickerView"]
                                 userInfo:nil];
}

#pragma mark - Container View

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

#pragma mark - Button Actions -



#pragma mark - Update Methods -

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
    });
}

#pragma mark - Delegate Methods -

- (void)datePickerViewController:(DatePickerViewController *)datePickerViewController
        didPresentViewController:(UIViewController *)viewController {
    [self updatePreviousAndNext];
}

- (void)datePickerViewControllerDidSwitchDatesWhileNested:(DatePickerViewController *)datePickerViewController {
    if ([self.currentDate isEqualToString:[DateHelper currentDate]]) {
        [self setTopViewController:[self appropriateHomeViewController]];
    } else if ([self.topViewController isKindOfClass:[DatePickerView class]]) {
        [self setTopViewController:[((DatePickerView *)self.topViewController) newInstance]];
    }
}

@end
