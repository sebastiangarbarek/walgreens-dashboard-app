//
//  DatePickerViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 2/08/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSMutableArray+Stack.h"

@protocol DatePickerViewControllerDelegate;

@interface DatePickerViewController : UIViewController

@property (nonatomic, weak) id <DatePickerViewControllerDelegate> delegate;

typedef NS_ENUM(NSInteger, Transition) {
    RightToLeft,
    LeftToRight
};

#pragma mark - Date Picker Navigation Bar -

@property (weak, nonatomic) NSString *currentDate;
@property (weak, nonatomic) NSString *homeDate;
@property (weak, nonatomic) NSString *nextDate;
@property (weak, nonatomic) NSString *previousDate;

@property (weak, nonatomic) UINavigationBar *dateNavigationBar;
@property (weak, nonatomic) UINavigationItem *dateNavigationItem;
@property (weak, nonatomic) UIBarButtonItem *previousButton;
@property (weak, nonatomic) UIBarButtonItem *nextButton;

#pragma mark - Main Navigation Bar -

@property (weak, nonatomic) UINavigationBar *mainNavigationBar;
@property (weak, nonatomic) UINavigationItem *mainNavigationItem;
@property (weak, nonatomic) UIBarButtonItem *backButton;
@property (weak, nonatomic) UIBarButtonItem *homeButton;

#pragma mark - View Container -

@property (strong, nonatomic) NSMutableArray *navigationStack;

@property (weak, nonatomic) UIViewController *currentViewController;
@property (weak, nonatomic) UIViewController *homeViewController;
@property (weak, nonatomic) UIViewController *nextViewController;
@property (weak, nonatomic) UIViewController *previousViewController;
@property (weak, nonatomic) UIViewController *topViewController;

@property (weak, nonatomic) UIView *containerView;

#pragma mark - Public Methods -

- (void)setCurrentViewController:(UIViewController *)currentViewController withDate:(NSString *)date;
- (void)setHomeViewController:(UIViewController *)viewController withDate:(NSString *)date;
- (void)setNextViewController:(UIViewController *)viewController withDate:(NSString *)date;
- (void)setPreviousViewController:(UIViewController *)viewController withDate:(NSString *)date;
// Top view controller uses property mutator and current date.

- (void)presentHomeViewController;
- (void)presentNextViewController;
- (void)presentPreviousViewController;

- (void)pushViewController:(UIViewController *)viewController;
- (void)popViewController;

- (void)updateDateTitle:(NSString *)title;
- (void)updateMainTitle:(NSString *)title;

@end

@protocol DatePickerViewControllerDelegate <NSObject>

@required
- (void)datePickerViewController:(DatePickerViewController *)datePickerViewController
        didPresentViewController:(UIViewController *)viewController;
- (void)datePickerViewControllerDidSwitchDatesWhileNested:(DatePickerViewController *)datePickerViewController;

@end
