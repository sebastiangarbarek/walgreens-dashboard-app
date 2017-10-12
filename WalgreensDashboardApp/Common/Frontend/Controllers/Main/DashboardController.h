//
//  DashboardController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "ViewController.h"
#import "StoreTimes.h"
#import "DashboardCountCell.h"
#import "UIColor+AppTheme.h"

@interface DashboardController : ViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property StoreTimes *storeTimes;
@property NSTimer *storeTimer;

// Progress view at the top of the screen below the navigation bar.
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

// Notification view overlay at the top of the screen below the navigation bar.
@property (weak, nonatomic) IBOutlet UIView *notificationView;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;


@end
