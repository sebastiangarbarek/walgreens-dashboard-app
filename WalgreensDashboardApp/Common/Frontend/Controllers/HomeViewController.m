//
//  HomeViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 29/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "HomeViewController.h"
#import "OfflineViewController.h"

@interface HomeViewController () {
    NSArray *sectionTitles;
    NSDictionary *cellTitles;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sectionTitles = @[@"UPDATE", @"SERVERS", @"STORES"];
    cellTitles = @{sectionTitles[0] : @[@""],
                   sectionTitles[1] : @[@"Store", @"Print"],
                   sectionTitles[2] : @[@"Online", @"Offline"]};
    
    self.tabBarController.delegate = self;
    self.date = [DateHelper currentDate];
    self.navigationItem.title = self.date;
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.title = self.date;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = [sectionTitles objectAtIndex:section];
    NSArray *sectionCells = [cellTitles objectForKey:sectionTitle];
    return [sectionCells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            UpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Update Cell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 1: {
            ServerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Server Cell" forIndexPath:indexPath];
            NSString *sectionTitle = [sectionTitles objectAtIndex:indexPath.section];
            NSArray *sectionCells = [cellTitles objectForKey:sectionTitle];
            NSString *cellTitle = [sectionCells objectAtIndex:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
            cell.serviceLabel.text = cellTitle;
            cell.serviceStatusLabel.text = @"Online";
            cell.serviceStatusLabel.textColor = [UIColor greenColor];
            return cell;
        }
        case 2: {
            StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Status Cell" forIndexPath:indexPath];
            NSString *sectionTitle = [sectionTitles objectAtIndex:indexPath.section];
            NSArray *sectionCells = [cellTitles objectForKey:sectionTitle];
            NSString *cellTitle = [sectionCells objectAtIndex:indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
            cell.statusLabel.text = cellTitle;
            cell.totalLabel.text = @"0 ";
            return cell;
        }
        default:
            break;
    }
    
    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    UINavigationController *navigationController = (UINavigationController *)viewController;
    UIViewController *root = navigationController.viewControllers[0];
    
    if ([root isKindOfClass:[OfflineViewController class]]) {
        OfflineViewController *offlineViewController = (OfflineViewController *)root;
        offlineViewController.date = self.date;
    }
}

- (IBAction)nextButton:(id)sender {
    
}

- (IBAction)previousButton:(id)sender {
    
}


@end
