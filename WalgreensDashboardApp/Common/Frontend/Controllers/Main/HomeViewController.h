//
//  HomeViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSMutableArray+Stack.h"
#import "DatePickerViewController.h"

@interface HomeViewController : DatePickerViewController

typedef NS_ENUM(NSInteger, Transition) {
    RightToLeft,
    LeftToRight,
    Push,
};

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *datePicker;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *dateTitle;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousButton;

@property (weak, nonatomic) IBOutlet UIView *containerView;
// The current table view controller in the container view, referenced to remove.
@property (weak, nonatomic) UITableViewController *currentTableViewController;

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *notificationsLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *requestProgressView;
@property (weak, nonatomic) IBOutlet UILabel *percentCompleteLabel;

@property (strong, nonatomic) NSMutableArray *navigationStack;

- (void)animateTransitionTo:(UITableViewController *)newVc transition:(Transition)transition;
- (void)popAnimate:(UITableViewController *)newVc;
- (void)switchBackButton;

@end
