//
//  MapController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 16/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "MapController.h"

@interface MapController () {
    NSMutableArray *annotations;
}

@end

@implementation MapController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"[WARNING] Browse stores map received memory warning.");
}

- (void)initData {
    annotations = [NSMutableArray new];
    
    // Apply cluster algorithm.
    CKGridBasedAlgorithm *algorithm = [CKGridBasedAlgorithm new];
    self.mapView.clusterManager.algorithm = algorithm;
    
    // Retrieve all print store coordinates.
    NSArray *results = [self.databaseManager.selectCommands selectAllStoreCords];
    
    // Build annotation array.
    for (NSDictionary *store in results) {
        ClusterPin *pin = [[ClusterPin alloc] init];
        pin.storeNumber = [store objectForKey:kStoreNum];
        pin.title = [[[store objectForKey:kAddr] lowercaseString] capitalizedString];
        pin.subtitle = [NSString stringWithFormat:@"Store #%@", [store objectForKey:kStoreNum]];
        pin.coordinate = CLLocationCoordinate2DMake([[store objectForKey:kLong] doubleValue], [[store objectForKey:kLat] doubleValue]);
        [annotations addObject:pin];
    }

    // Load annotation data into map.
    self.mapView.clusterManager.annotations = annotations;
    
    // Set region to centre the United States.
    CLLocationCoordinate2D unitedStates = CLLocationCoordinate2DMake(36.2158881, -113.6882983);
    MKCoordinateRegion region = MKCoordinateRegionMake(unitedStates, MKCoordinateSpanMake(75, 100));
    [self.mapView setRegion:region animated:NO];
}

#pragma mark Cluster Kit Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // Try dequeue an existing view.
    static NSString *identifier = @"annotation";
    MKAnnotationView *annotationView = (id)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (!annotationView) {
        // If no view exists, create a new one with the identifier to be reused later.
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    
    if ([annotation isKindOfClass:[CKCluster class]]) {
        CKCluster *cluster = (CKCluster *)annotation;
        if (cluster.count > 1) {
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"MapCluster"];
            
        } else {
            // Add disclosure with action.
            UIButton *disclosure = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [disclosure addTarget:self action:@selector(showStoreDetails) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = disclosure;
            
            // Additional setup.
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"Marker"];
        }
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [mapView.clusterManager updateClustersIfNeeded];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[CKCluster class]]) {
        CKCluster *cluster = (CKCluster *)view.annotation;
        
        if (cluster.count > 1) {
            UIEdgeInsets edgePadding = UIEdgeInsetsMake(40, 20, 44, 20);
            [mapView showCluster:cluster edgePadding:edgePadding animated:YES];
        } else {
            // CK uses wrapper CKCentroidCluster in place of normal or custom annotation. We must first retrieve that.
            CKCentroidCluster *centroidCluster = (CKCentroidCluster *)view.annotation;
            
            // Get the selected store number from the custom annotation.
            ClusterPin *pin = (ClusterPin *)centroidCluster.firstAnnotation;
            self.storeNumber = pin.storeNumber;
            
            // Display the annotation.
            [mapView.clusterManager selectAnnotation:cluster.firstAnnotation animated:NO];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[CKCluster class]]) {
        CKCluster *cluster = (CKCluster *)view.annotation;
        [mapView.clusterManager deselectAnnotation:cluster.firstAnnotation animated:NO];
    }
}

#pragma mark - Navigation Methods -

- (void)showStoreDetails {
    // Selected store number is stored in this class.
    [self.segueDelegate child:self willPerformSegueWithIdentifier:@"Store Details"];
}

@end
