//
//  StoreCategoryController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 16/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "StoreStateController.h"
#import "StoreCityController.h"
#import "MapController.h"
#import "SegueProtocol.h"

@interface StoreCategoryController : ViewController <SegueProtocol>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic) UIViewController *listController;
@property (nonatomic) UIViewController *mapController;

@end
