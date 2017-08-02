//
//  HomeViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousButton;

// The current table view controller in the container view, referenced to remove.
@property (weak, nonatomic) UITableViewController *currentTableViewController;

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *nextDate;
@property (strong, nonatomic) NSString *previousDate;

@end
