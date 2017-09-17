//
//  ClusterPin.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 17/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <ClusterKit/MKMapView+ClusterKit.h>

@interface ClusterPin : NSObject <CKAnnotation>

@property NSString *storeNumber;

@property (weak, nonatomic) CKCluster *cluster;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@end
