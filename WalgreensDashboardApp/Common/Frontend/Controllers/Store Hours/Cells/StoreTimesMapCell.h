//
//  StoreTimesMapCell.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 20/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <ClusterKit/MKMapView+ClusterKit.h>

#import "ClusterPin.h"
#import "DatabaseConstants.h"
#import "StoreTimes.h"
#import "SegueDelegate.h"

@interface StoreTimesMapCell : UITableViewCell <MKMapViewDelegate>

@property (weak, nonatomic) id <SegueDelegate> segueDelegate;

@property NSString *storeNumber;

@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (void)loadWithoutStores;
- (void)loadWithStores:(NSArray *)stores;

@end
