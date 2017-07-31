//
//  OfflineViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 30/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "OfflineViewController.h"
#import "HomeViewController.h"

@interface OfflineViewController ()

@end

@implementation OfflineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = self.date;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // Pass the current date to the offline view.
    if ([viewController isKindOfClass:[HomeViewController class]]) {
        HomeViewController *homeViewController = (HomeViewController *)viewController;
        homeViewController.date = self.date;
    }
}

- (IBAction)nextButton:(id)sender {
    
}

- (IBAction)previousButton:(id)sender {
    
}

@end
