//
//  MapCell.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "MapPin.h"

@interface MapCell : UITableViewCell <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (void)placeStoreOnMapWithLatitude:(NSString *)latitude longitude:(NSString *)longitude;

@end
