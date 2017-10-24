//
//  ProductListController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 5/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "ViewController.h"

#import "ProductCell.h"
#import "DatabaseConstants.h"
#import "Reachability.h"
#import "UIColor+AppTheme.h"

@interface ProductListController : ViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *notificationView;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;

@end
