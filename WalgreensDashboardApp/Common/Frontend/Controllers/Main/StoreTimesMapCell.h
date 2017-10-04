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
#import "SegueProtocol.h"

@interface StoreTimesMapCell : UITableViewCell <MKMapViewDelegate>

@property (weak, nonatomic) id <SegueProtocol> segueDelegate;

@property NSString *storeNumber;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (void)loadWithoutStores;
- (void)loadWithStores:(NSArray *)stores;

@end
