//
//  StoreStateController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 15/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreCell.h"
#import "StoreCategoryController.h"
#import "TableViewController.h"
#import "StoreCityController.h"

@protocol SegueDelegate;

@interface StoreStateController : TableViewController

@property (weak, nonatomic) id <SegueDelegate> segueDelegate;

// Public as accessed by parent StoreCategoryController for segue. Could instead pass data using delegation.
@property NSMutableDictionary *cellsToSectionAbbr;
@property NSArray *sectionTitles;

@end
