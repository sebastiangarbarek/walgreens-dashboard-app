//
//  MapController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 16/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <ClusterKit/MKMapView+ClusterKit.h>
#import "ClusterPin.h"
#import "ViewController.h"
#import "StoreCategoryController.h"
#import "DatabaseConstants.h"

@protocol SegueDelegate;

@interface MapController : ViewController <MKMapViewDelegate>

@property (weak, nonatomic) id <SegueDelegate> segueDelegate;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

// Selected store number.
@property NSString *storeNumber;

@end
