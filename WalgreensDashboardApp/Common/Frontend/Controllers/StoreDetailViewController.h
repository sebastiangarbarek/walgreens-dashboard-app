//
//  StoreDetailViewController.h
//  WalgreensDashboardMock
//
//  Created by Sebastian Garbarek on 29/04/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "TemporaryData.h"
#import "WalgreensAPI.h"

@interface StoreDetailViewController : UIViewController <WalgreensAPIDelegate> {
    double latitude;
    double longitude;
}

@property (weak, nonatomic) NSString *selectedStoreNumber;

@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *printStatusLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (BOOL)isPhoneNumber:(NSString *)string;
- (BOOL)isCoordinate:(NSString *)string;
- (BOOL)isCoordinateValid:(double)lat :(double)lng;

@end
