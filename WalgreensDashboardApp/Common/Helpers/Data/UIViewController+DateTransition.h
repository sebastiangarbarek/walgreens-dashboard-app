//
//  UIViewController+DateTransition.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 1/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DashboardController.h"

@interface UIViewController (DateTransition)

@property (weak, nonatomic) NSString *date;

- (void)prepareForTransition:(UIViewController *)viewController;

@end
