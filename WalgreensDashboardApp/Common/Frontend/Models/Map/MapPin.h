//
//  MapPin.h
//  WalgreensDashboardMock
//
//  Created by Nan on 2017/5/3.
//  Copyright © 2017年 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *title;
}

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;

@end
