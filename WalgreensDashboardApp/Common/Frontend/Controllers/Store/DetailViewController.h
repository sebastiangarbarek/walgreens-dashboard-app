//
//  DetailViewController.h
//  WalgreensDashboardApp
//
//  Created by NAN JIANG on 2017/8/12.
//  Copyright © 2017年 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    double latitude;
    double longitude;
}
@property (strong, nonatomic) IBOutlet UILabel *storeNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *storeAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *callBtn;
@property (nonatomic,strong) NSDictionary *recivedDictionary;

- (BOOL)isPhoneNumber:(NSString *)string;
- (BOOL)isCoordinate:(NSString *)string;
- (BOOL)isCoordinateValid:(double)lat :(double)lng;

@end
