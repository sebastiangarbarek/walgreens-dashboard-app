//
//  StoreCityController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 15/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreCell.h"
#import "TableViewController.h"
#import "StoreDetailsController.h"
#import "DatabaseConstants.h"
#import "Store.h"

@interface StoreCityController : TableViewController

// Can pass in filtered stores by setting this, e.g. currently open stores.
@property NSArray *stores;

@property NSString *state;
@property NSString *navigationTitle;

@end
