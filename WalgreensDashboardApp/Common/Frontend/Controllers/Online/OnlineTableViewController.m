//
//  OnlineTableViewController.m
//  WalgreensDashboardApp
//
//  Created by Naomi Wu on 13/08/17.
//  Copyright © 2017 Naomi Wu. All rights reserved.
//

#import "HomeViewController.h"
#import "OnlineTableViewController.h"
#import "OnlineCell.h"
#import "DatabaseManagerApp.h"
#import "DatabaseManager.h"

@interface OnlineTableViewController () {
    
    DatabaseManagerApp *databaseManagerApp;
    NSMutableArray *onlineStores;
    NSMutableArray *StateList;
    NSString *displayMode;
    
}

@end

@implementation OnlineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    // Database closes itself after use.
    [databaseManagerApp openCreateDatabase];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.date = ((HomeViewController *)self.parentViewController).date;
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return state count
    StateList = [databaseManagerApp.selectCommands selectStatesInStoreDetail];
    return [StateList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OnlineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Online Cell" forIndexPath:indexPath];
    
    // Display state to cell
    
        NSString *state = [StateList[indexPath.row] objectForKey:@"state"];
        if ([state length] != 0) {
            state = [state stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.onlineStoreLabel.text = [NSString stringWithFormat:@"%@",state];
        } else {
            // Details unknow
            cell.onlineStoreLabel.text = [NSString stringWithFormat:@"(state unknow)"];
        }
        return cell;
    
    
    /*
    
    // Display cities with state to cell
    if ([displayMode isEqualToString:@"city"]) {
        NSString *state = [[SelectCommands alloc] init].selectStatesInStoreDetail[indexPath.row];
        NSString *currentState;
        NSString *city = [[onlineStores objectAtIndex:indexPath.row] objectForKey:@"city"];
        if ([currentState isEqualToString:state]) {
            if ([city length] != 0) {
                city = [city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                cell.onlineStoreLabel.text = [NSString stringWithFormat:@"Store #%@(%@ %@)", [[[onlineStores objectAtIndex:indexPath.row]
                                                                                            objectForKey:@"storeNum"] stringValue], currentState, city];
            }
            // State is null
            else {
                // Details unknown.
                cell.onlineStoreLabel.text = [NSString stringWithFormat:@"Store #%@ (details unknown)", [[[onlineStores objectAtIndex:indexPath.row]
                                                                                                          objectForKey:@"storeNum"] stringValue]];
            }
        }
        return cell;
    }
    
    // Display stores with city
    if ([displayMode isEqualToString:@"storeNum"]) {
        NSString *city = [[onlineStores objectAtIndex:indexPath.row] objectForKey:@"city"];
        
        if ([city length] != 0) {
            city = [city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.onlineStoreLabel.text = [NSString stringWithFormat:@"Store #%@(%@)", [[[onlineStores objectAtIndex:indexPath.row]
                                                                                        objectForKey:@"storeNum"] stringValue], city];
            
        } else {
            // Details unknow
            cell.onlineStoreLabel.text = [NSString stringWithFormat:@"Store #%@ (details unknow)", [[[onlineStores objectAtIndex:indexPath.row]
                                                                                                 objectForKey:@"storeNum"] stringValue]];
        }
        return cell;
    }*/
}

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

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
            // Store status section
        case 0: {
            
                    // Get home view.
                    HomeViewController *homeViewController = (HomeViewController *)self.parentViewController;
                    
                    // Swap container view.
                    UIStoryboard *cityListStoryBoard = [UIStoryboard storyboardWithName:@"CityList" bundle:nil];
                    UITableViewController *cityListTableViewController = [cityListStoryBoard instantiateViewControllerWithIdentifier:@"City Table View"];
                    [homeViewController animateTransitionTo:cityListTableViewController transition:Push];
                    
                    [homeViewController switchBackButton];
                    break;
        }
            // Store hours section
        case 1: {
            break;
        }
    }
    // Push selected view onto navigation stack.
}

*/
@end
