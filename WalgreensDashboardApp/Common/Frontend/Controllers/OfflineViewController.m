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
    self.navigationItem.title = self.date;
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.title = self.date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Store Cell" forIndexPath:indexPath];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    UINavigationController *navigationController = (UINavigationController *)viewController;
    UIViewController *root = navigationController.viewControllers[0];
    
    if ([root isKindOfClass:[HomeViewController class]]) {
        HomeViewController *homeViewController = (HomeViewController *)root;
        homeViewController.date = self.date;
        homeViewController.title = self.date;
    }
}

- (IBAction)nextButton:(id)sender {
    
}

- (IBAction)previousButton:(id)sender {
    
}

@end
