//
//  DetailViewController.m
//  WalgreensDashboardApp
//
//  Created by NAN JIANG on 2017/8/12.
//  Copyright © 2017年 Sebastian Garbarek. All rights reserved.
//

#import "DetailViewController.h"
#import "MapPin.h"
#import "DatabaseManager.h"


@interface DetailViewController ()

@end

@implementation DetailViewController{
    NSString *storePhone;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    //NSString *storeNumber = [NSString stringWithFormat:@"Store #%@", [_selectedStoreNumber description]];
    _recivedArray = [[NSMutableArray alloc] init];
    NSLog(@"=%@=",_recivedArray);
    // Call the requestStoreDetails method.
    // [walgreensAPI requestStoreDetails:_selectedStoreNumber];

    /*
     [_printStatusLabel setHidden:YES];
     [_storeStatusLabel setHidden:YES];
     [_contactLabel setHidden:YES];
     [_storeAddressLabel setHidden:YES];
     [_callBtn setHidden:YES];
     [_mapView setHidden:YES];
     */
}
/*
- (void)getStoreDetailsFromDictionary {
    
    self.contactLabel.text = [NSString stringWithFormat:@"Phone Number: %@", [_recivedArray objectForKey:@"storePhoneNum"]];
    self.storeAddressLabel.text = [NSString stringWithFormat:@"Store Address: %@", [row objectForKey:@"street"]];
    
    storePhone = [NSString stringWithFormat:@"%@", [row objectForKey:@"storePhoneNum"]];
    
    if (storePhone == nil) {
        self.callBtn.backgroundColor = [UIColor lightGrayColor];
        self.callBtn.enabled = NO;
    } else {
        self.callBtn.enabled = YES;
        self.callBtn.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    
    NSString *phoneDetail = [NSString stringWithFormat:@"Phone: %@", storePhone];
    self.contactLabel.text = phoneDetail;
    
    [self pinStoreOnMapWithLatitude:[row objectForKey:@"longitude"] andLongitude:[row objectForKey:@"latitude"] andPinTitle:[row objectForKey:@"street"]];
}

- (void)pinStoreOnMapWithLatitude:(NSString *)latS andLongitude:(NSString *)longS andPinTitle:(NSString *)pinTitle {
    if ([self isCoordinate:latS] && [self isCoordinate:longS]) {
        double latD = [latS doubleValue];
        double longD = [longS doubleValue];
        
        MKCoordinateRegion region = {{0.0,0.0},{0.0,0.0}};
        region.center.latitude = latD;
        region.center.longitude = longD;
        region.span.latitudeDelta = 0.01f;
        region.span.longitudeDelta = 0.01f;
        [self.mapView setRegion:region animated:YES];
        
        MapPin *ann = [[MapPin alloc]init];
        ann.title = pinTitle;
        ann.coordinate = region.center;
        
        self.mapView.layer.cornerRadius = 10;
        self.contactLabel.layer.cornerRadius = 10;
        self.callBtn.layer.cornerRadius = 5;
        [self.mapView addAnnotation:ann];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Helper Methods -

- (void)displayOKAlertwithTitle:(NSString *)title withMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        return;
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


/*
 Phone numbers from the Walgreens API are returned as a string of numbers.
 The phone numbers don't contain any other characters, this is presumably so that
 it is easier to call the number and also easier to test.
 */
/*

- (IBAction)callBtnAction:(id)sender {
    // Get the device type.
    NSString *deviceType = [UIDevice currentDevice].model;
    
    // Check if the device can make a phone call.
    if ([deviceType isEqualToString:@"iPod touch"] || [deviceType isEqualToString:@"iPad"] || [deviceType  isEqualToString:@"iPhone Simulator"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"This Number Can't Be Called." message:@"Your device does not support making phone calls." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            return;
        }];
        
        [alertController addAction:yesAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        if ([self isPhoneNumber:storePhone]) {
            NSString *phone = [NSString stringWithFormat:@"tel://%@",storePhone];
            
            // Remove any white space, if any
            NSString *url = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSURL *telURL = [NSURL URLWithString:url];
            // Make the phone call.
            UIApplication *application =[UIApplication sharedApplication];
            [application openURL:telURL options:@{} completionHandler:nil];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"This Number Can't Be Called."
                                                                                     message:@"Please correct its format and call it manually."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                return;
            }];
            
            [alertController addAction:yesAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (BOOL)isPhoneNumber:(NSString *)string {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    // If any characters remain this string is not a phone number.
    if (string.length > 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isCoordinate:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"-"withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    // If any characters remain this string is not a coordinate.
    if (string.length > 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isCoordinateValid:(double)lat :(double)lng {
    if (lat <= 90.0 && lat >= -90.0) {
        if (lng <= 180.0 && lng >=- 180.0) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return YES;
    }
}
*/
@end
