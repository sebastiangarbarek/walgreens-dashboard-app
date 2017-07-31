//
//  OfflineViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 30/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfflineViewController : UIViewController <UITabBarControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousButton;

@property (strong, nonatomic) NSString *date;

@end
