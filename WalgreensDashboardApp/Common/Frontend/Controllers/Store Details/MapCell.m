//
//  MapCell.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "MapCell.h"

@implementation MapCell

- (void)placeStoreOnMapWithLatitude:(NSString *)latitude longitude:(NSString *)longitude {
    if (latitude != nil && longitude != nil) {
        double lat = [latitude doubleValue];
        double lng = [longitude doubleValue];
        
        MKCoordinateRegion region = {{0.0,0.0},{0.0,0.0}};
        region.center.latitude = lat;
        region.center.longitude = lng;
        region.span.latitudeDelta = 0.01f;
        region.span.longitudeDelta = 0.01f;
        [self.mapView setRegion:region animated:YES];
        
        MapPin *pin = [[MapPin alloc] init];
        pin.title = @"Store Location";
        pin.coordinate = region.center;
        
        [self.mapView addAnnotation:pin];
    }
}

@end
