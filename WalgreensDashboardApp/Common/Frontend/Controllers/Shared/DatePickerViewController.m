//
//  DatePickerViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 3/08/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DatePickerViewController.h"

static double const AnimationDuration = 0.15;

@implementation DatePickerViewController

#pragma mark - Parent Methods -

- (void)awakeFromNib {
    [super awakeFromNib];
    self.navigationStack = [NSMutableArray new];
    [self embedInitialViewController];
}

#pragma mark - Public Methods -

- (void)setCurrentViewController:(UIViewController *)viewController withDate:(NSString *)date {
    if (viewController) {
        _currentViewController = viewController;
        _currentDate = date;
    }
}

- (void)setHomeViewController:(UIViewController *)viewController withDate:(NSString *)date {
    if (viewController) {
        _homeViewController = viewController;
        _homeDate = date;
    }
}

- (void)setNextViewController:(UIViewController *)viewController withDate:(NSString *)date {
    if (viewController) {
        _nextViewController = viewController;
        _nextDate = date;
        self.nextButton.enabled = YES;
    }
}

- (void)setPreviousViewController:(UIViewController *)viewController withDate:(NSString *)date {
    if (viewController) {
        _previousViewController = viewController;
        _previousDate = date;
        self.previousButton.enabled = YES;
    }
}

- (void)presentHomeViewController {
    if (_currentViewController != _homeViewController) {
        [self animateTransitionWithViewController:_homeViewController transition:RightToLeft];
        [self updateDateTitle:_homeDate];
    }
}

- (void)presentNextViewController {
    // Disable the next button.
    self.nextButton.enabled = NO;
    if (_nextViewController) {
        if (!_navigationStack.isEmpty) {
            // User switched dates while nested. Delegate call should set top view controller.
            [self.delegate datePickerViewControllerDidSwitchDatesWhileNested:self];
        }
        [self animateTransitionWithViewController:_nextViewController
                                       transition:RightToLeft];
        [self updateDateTitle:_nextDate];
    }
}

- (void)presentPreviousViewController {
    // Disable the previous button.
    self.previousButton.enabled = NO;
    if (_previousViewController) {
        if (!_navigationStack.isEmpty) {
            // User switched dates while nested. Delegate call should set top view controller.
            [self.delegate datePickerViewControllerDidSwitchDatesWhileNested:self];
        }
        [self animateTransitionWithViewController:_previousViewController
                                       transition:LeftToRight];
        [self updateDateTitle:_previousDate];
    }
}

- (void)pushViewController:(UIViewController *)viewController {
    if (viewController) {
        // Push the current view controller onto the stack, not the new view controller.
        [self.navigationStack push:_currentViewController];
        [self animatePushWithViewController:viewController];
        [self enableBackButton];
    }
}

- (void)popViewController {
    if (!_navigationStack.isEmpty) {
        [self animatePopWithViewController:_navigationStack.pop];
    } else if (_topViewController) {
        // User had switched dates while nested.
        [self animatePopWithViewController:_topViewController];
        // Destroy the reference to the top view controller for the next check.
        _topViewController = nil;
    }
    
    if (_navigationStack.isEmpty && !_topViewController)
        [self disableBackButton];
}

- (void)updateDateTitle:(NSString *)title {
    self.dateNavigationItem.title = title;
}

- (void)updateMainTitle:(NSString *)title {
    self.mainNavigationItem.title = title;
}

#pragma mark - U.I. Methods -

- (void)embedInitialViewController {
    
}

- (void)animatePushWithViewController:(UIViewController *)newViewController {
    [_currentViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    
    CGFloat width = self.containerView.bounds.size.width;
    CGFloat height = self.containerView.bounds.size.height;
    newViewController.view.frame = CGRectMake(width, 0, width, height);
    
    [self transitionFromViewController:_currentViewController
                      toViewController:newViewController
                              duration:AnimationDuration
                               options:0
                            animations:^{ newViewController.view.frame = self.containerView.bounds; }
                            completion:^(BOOL finished) {
        [newViewController didMoveToParentViewController:self];
        [_currentViewController removeFromParentViewController];
        self.currentViewController = newViewController;
    }];
}

- (void)animatePopWithViewController:(UIViewController *)newViewController {
    // Add the table view controller as a child to this.
    [self addChildViewController:newViewController];
    // Size the new view controller to fit in the container view.
    newViewController.view.frame = self.containerView.bounds;
    // Add the controller's view as a subview to the container view.
    [self.containerView addSubview:newViewController.view];
    // Bring the current view controller to the front for pop animation.
    [self.containerView bringSubviewToFront:self.currentViewController.view];
    
    CGFloat width = self.containerView.bounds.size.width;
    CGFloat height = self.containerView.bounds.size.height;
    
    [UIView animateWithDuration:AnimationDuration
                     animations:^ { self.currentViewController.view.frame = CGRectMake(width, 0, width, height); }
                     completion:^(BOOL finised) {
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = newViewController;
    }];
}

- (void)animateTransitionWithViewController:(UIViewController *)newViewController transition:(Transition)transition {
    [_currentViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    
    CGFloat width = self.containerView.bounds.size.width;
    CGFloat height = self.containerView.bounds.size.height;
    
    switch (transition) {
        case RightToLeft:
            newViewController.view.frame = CGRectMake(width, 0, width, height);
            break;
        case LeftToRight:
            newViewController.view.frame = CGRectMake(-width, 0, width, height);
            break;
        default:
            break;
    }
    
    [self transitionFromViewController:_currentViewController
                      toViewController:newViewController
                              duration:AnimationDuration
                               options:0
                            animations:^{
        newViewController.view.frame = self.containerView.bounds;
        switch (transition) {
            case RightToLeft:
                _currentViewController.view.frame = CGRectMake(-width, 0, width, height);
                break;
            case LeftToRight:
                _currentViewController.view.frame = CGRectMake(width, 0, width, height);
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [newViewController didMoveToParentViewController:self];
        [_currentViewController removeFromParentViewController];
        self.currentViewController = newViewController;
        
        // Delegate call should update the next and previous view controllers and buttons respectively.
        [self.delegate datePickerViewController:self
                       didPresentViewController:_previousViewController];
    }];
}

- (void)enableBackButton {
    [self.backButton setEnabled:YES];
    [self.backButton setTintColor:nil];
}

- (void)disableBackButton {
    [self.backButton setEnabled:NO];
    [self.backButton setTintColor:[UIColor clearColor]];
}

- (void)removeBottomNavigationBarLine {
    [self.mainNavigationBar setShadowImage:[[UIImage alloc] init]];
    [self.mainNavigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

- (void)addShadow {
    CGRect dateNavigationBarBounds = self.dateNavigationBar.bounds;
    dateNavigationBarBounds.size.width = [[UIScreen mainScreen] bounds].size.width;
    dateNavigationBarBounds.origin.y = dateNavigationBarBounds.size.height / 2;
    dateNavigationBarBounds.size.height = dateNavigationBarBounds.size.height / 2;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:dateNavigationBarBounds];
    self.dateNavigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.dateNavigationBar.layer.shadowOffset = CGSizeMake(0.0f, 0.1f);
    self.dateNavigationBar.layer.shadowOpacity = 0.25f;
    self.dateNavigationBar.layer.shadowPath = shadowPath.CGPath;
}

@end
