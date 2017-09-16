//
//  StoreCategoryController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 16/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "StoreStateController.h"
#import "StoreCityController.h"

@protocol SegueDelegate <NSObject>

@required
- (void)child:(UIViewController *)childViewController willPushViewController:(NSString *)viewControllerIdentifier withSegueIdentifier:(NSString *)segueIdentifier;

@end

@interface StoreCategoryController : ViewController <SegueDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic) UIViewController *listController;
@property (nonatomic) UIViewController *mapController;

@end
