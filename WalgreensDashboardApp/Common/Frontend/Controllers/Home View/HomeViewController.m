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
#import "OfflineTableViewController.h"

@interface HomeViewController ()


@end

@implementation HomeViewController

@dynamic dateTitle;
@dynamic nextButton;
@dynamic previousButton;

#pragma mark - View Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationStack = [NSMutableArray new];
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
    
    // Add shadow to date picker.
    CGRect datePickerBounds = self.datePicker.bounds;
    datePickerBounds.size.width = [[UIScreen mainScreen] bounds].size.width;
    datePickerBounds.origin.y = datePickerBounds.size.height / 2;
    datePickerBounds.size.height = datePickerBounds.size.height / 2;
    UIBezierPath *datePickerShadowPath = [UIBezierPath bezierPathWithRect:datePickerBounds];
    self.datePicker.layer.shadowColor = [UIColor blackColor].CGColor;
    self.datePicker.layer.shadowOffset = CGSizeMake(0.0f, 0.1f);
    self.datePicker.layer.shadowOpacity = 0.25f;
    self.datePicker.layer.shadowPath = datePickerShadowPath.CGPath;
    
    // Add shadow to update view.
    CGRect updateViewBounds = self.progressView.bounds;
    updateViewBounds.size.width = [[UIScreen mainScreen] bounds].size.width;
    UIBezierPath *updateViewShadowPath = [UIBezierPath bezierPathWithRect:updateViewBounds];
    self.progressView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.progressView.layer.shadowOffset = CGSizeMake(0.0f, -0.1f);
    self.progressView.layer.shadowOpacity = 0.25f;
    self.progressView.layer.shadowPath = updateViewShadowPath.CGPath;
    
    [self embedInitialTableView];
}

#pragma mark - Container View

- (void)animateTransitionTo:(UITableViewController *)newVc transition:(Transition)transition {
    UITableViewController *current = self.currentTableViewController;
    
    [current willMoveToParentViewController:nil];
    [self addChildViewController:newVc];
    
    CGFloat width = self.containerView.bounds.size.width;
    CGFloat height = self.containerView.bounds.size.height;
    
    switch (transition) {
        case RightToLeft:
            newVc.view.frame = CGRectMake(width, 0, width, height);
            break;
        case LeftToRight:
            newVc.view.frame = CGRectMake(-width, 0, width, height);
            break;
        case Push:
            newVc.view.frame = CGRectMake(width, 0, width, height);
            break;
        default:
            break;
    }
    
    [self transitionFromViewController:current toViewController:newVc duration:0.25 options:0 animations:^{
        newVc.view.frame = self.containerView.bounds;
        switch (transition) {
            case RightToLeft:
                current.view.frame = CGRectMake(-width, 0, width, height);
                break;
            case LeftToRight:
                current.view.frame = CGRectMake(width, 0, width, height);
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [newVc didMoveToParentViewController:self];
        [current removeFromParentViewController];
        
        self.currentTableViewController = newVc;
        
        if (transition == Push) {
            [self.navigationStack push:newVc];
        }
    }];
}

- (void)popAnimate:(UITableViewController *)newVc {
    // Add the table view controller as a child to this.
    [self addChildViewController:newVc];
    
    // Size the new table view controller to fit in the container view.
    newVc.view.frame = self.containerView.bounds;
    
    // Add the view as a subview to the container view.
    [self.containerView addSubview:newVc.view];
    
    // Bring current view controller to the front for pop animation.
    [self.containerView bringSubviewToFront:self.currentTableViewController.view];
    
    CGFloat width = self.containerView.bounds.size.width;
    CGFloat height = self.containerView.bounds.size.height;
    [UIView animateWithDuration:0.25 animations:^ {
        self.currentTableViewController.view.frame = CGRectMake(width, 0, width, height);
    } completion:^(BOOL finised) {
        [self.currentTableViewController.view removeFromSuperview];
        [self.currentTableViewController removeFromParentViewController];
        
        [self.navigationStack push:newVc];
        self.currentTableViewController = newVc;
    }];
}

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

- (void)datePickerSwapViewWithDirection:(Transition)direction {
    UITableViewController *tableViewController;
    
    if ([self.currentTableViewController isKindOfClass:[OfflineTableViewController class]]) {
        UIStoryboard *offlineStoryBoard = [UIStoryboard storyboardWithName:@"OfflineView" bundle:nil];
        tableViewController = [offlineStoryBoard instantiateViewControllerWithIdentifier:@"Offline Table View"];
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
