//
//  StoreCategoryController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 14/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "TableViewController.h"
#import "StoreCell.h"
#import "StoreDetailsController.h"

@interface StoreCategoryController : TableViewController

@property NSArray *categories;
@property NSMutableDictionary *storesToCategory;

- (void)initData;

@end
