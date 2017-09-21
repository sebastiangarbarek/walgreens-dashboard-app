//
//  UIViewController+DateTransition.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 1/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "UIViewController+DateTransition.h"

@implementation UIViewController (DateTransition)

/*!Wrapper method for simpler view transitions.
 */
- (void)prepareForTransition:(UIViewController *)viewController {
    if ([self.parentViewController isKindOfClass:[HomeViewController class]]) {
        HomeViewController *homeViewController = (HomeViewController *)self.parentViewController;
        [homeViewController pushViewController:viewController];
    } else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Extension method used in wrong context"
                                     userInfo:nil];
    }
}

@end
