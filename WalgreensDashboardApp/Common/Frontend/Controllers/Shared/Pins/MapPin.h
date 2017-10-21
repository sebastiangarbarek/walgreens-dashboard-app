//
//  MapPin.h
//  WalgreensDashboardMock
//
//  Created by Nan on 2017/5/3.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject <MKAnnotation>

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;

@end
