//
//  HomeViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 29/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServerCell.h"
#import "StatusCell.h"
#import "UpdateCell.h"
#import "DateHelper.h"

@interface HomeViewController : UITableViewController <UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (strong, nonatomic) NSString *date;

@end
