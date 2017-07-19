//
//  StoreDetailViewController.m
//  WalgreensDashboardMock
//
//  Created by Sebastian Garbarek on 29/04/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "MapPin.h"
#import "DatabaseManager.h"
#import "SharedCommands.h"

@interface StoreDetailViewController (){
    WalgreensAPI *walgreensAPI;
}

@end

@implementation StoreDetailViewController {
    DatabaseManager *databaseManager;
    NSString *storePhone;
    NSDictionary *recivedDictionary;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    /*
    // Create the right navigation bar button.
    UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(requestData)];
     
     // Add the refresh button to the navigation bar.
     self.navigationItem.rightBarButtonItem = rightButtonItem;
     */
    
    // Set the navigation bar title.
    NSString *storeNumber = [NSString stringWithFormat:@"Store #%@", [_selectedStoreNumber description]];
    self.navigationItem.title = storeNumber;
    
    walgreensAPI = [[WalgreensAPI alloc] init];
    //[walgreensAPI.delegate self];
    walgreensAPI.delegate = self;
    
    // Turn on the network activity indicator.
    [_activityIndicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Call the requestStoreDetails method.
    [walgreensAPI requestStoreDetails:_selectedStoreNumber];
    
    databaseManager = [[DatabaseManager alloc] initWithDatabaseFilename:WalgreensAPIDatabaseFilename];
    [self getStoreDetailsFromDatabase];
    
    /*
    [_printStatusLabel setHidden:YES];
    [_storeStatusLabel setHidden:YES];
    [_contactLabel setHidden:YES];
    [_storeAddressLabel setHidden:YES];
    [_callBtn setHidden:YES];
    [_mapView setHidden:YES];
     */
}

- (void)getStoreDetailsFromDatabase {
    NSArray *result = [databaseManager executeQuery:[[NSString stringWithFormat:@"SELECT * FROM store_detail WHERE storeNum = %@", _selectedStoreNumber] UTF8String]];
    
    NSDictionary *row = result[0];
    
    self.contactLabel.text = [NSString stringWithFormat:@"Phone Number: %@", [row objectForKey:@"storePhoneNum"]];
    self.storeStatusLabel.text = [NSString stringWithFormat:@"Store Status: %@", [row objectForKey:@"storeStatus"]];
    self.storeAddressLabel.text = [NSString stringWithFormat:@"Store Address: %@", [row objectForKey:@"street"]];
    self.printStatusLabel.text = [NSString stringWithFormat:@"Print Status: %@", [row objectForKey:@"photoStatusCd"]];
    
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
        self.storeStatusLabel.layer.cornerRadius = 10;
        self.contactLabel.layer.cornerRadius = 10;
        self.callBtn.layer.cornerRadius = 5;
        [self.mapView addAnnotation:ann];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)callBtn:(id)sender {
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

- (void)requestData {
    // Turn on the network activity indicator.
    [_activityIndicator startAnimating];
    
    self.contactLabel.text = @"Phone Number: Loading...";
    self.storeStatusLabel.text = @"Store Status: Loading...";
    self.storeAddressLabel.text = @"Store Address: Loading...";
    self.printStatusLabel.text = @"Print Status: Loading...";
    [_printStatusLabel setHidden:YES];
    [_storeStatusLabel setHidden:YES];
    [_contactLabel setHidden:YES];
    [_storeAddressLabel setHidden:YES];
    [_callBtn setHidden:YES];
    [_mapView setHidden:YES];
    
    // Remove the annotations on the map
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // Call the requestStoreDetails method.
    [walgreensAPI requestStoreDetails:_selectedStoreNumber];
}

-(void)readDataFromDictionary:(NSDictionary *)dictionary{
    /*
        NSDictionary *dicForStoreDetail = [Dictionary objectForKey:@"store"];
        //convert longtitude from string to double.
        NSString *getLongitude = [dicForStoreDetail objectForKey:@"longitude"];
        NSString *getLatitude = [dicForStoreDetail objectForKey:@"latitude"];
    
        //Check if the longitude and latitude is numeric
        if([self isCoordinate:getLatitude]&&[self isCoordinate:getLongitude]){
            double convertLongitude = [getLongitude doubleValue];
            //convert latitude from string to double.
            double convertLatitude = [getLatitude doubleValue];
            //To check if the longitude and latitude overrange
            if([self isCoordinateValid:convertLatitude :convertLongitude]){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"The longitude or latitude is over range." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    return;
                }];
                [alertController addAction:yesAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }else{
                //set longtitude and latitude.
                longitude = convertLongitude;
                latitude = convertLatitude;
                
                //set map region
                MKCoordinateRegion region = {{0.0,0.0},{0.0,0.0}};
                region.center.latitude = latitude;
                region.center.longitude = longitude;
                region.span.latitudeDelta = 0.01f;
                region.span.longitudeDelta = 0.01f;
                [self.mapView setRegion:region animated:YES];
                
                //init the map pin.
                MapPin *ann = [[MapPin alloc]init];
                //set the pin title.
                ann.title = [dicForStoreDetail objectForKey:@"street"];
                ann.coordinate = region.center;
                
                //set views cornerRadius
                self.mapView.layer.cornerRadius = 10;
                self.storeStatusLabel.layer.cornerRadius = 10;
                self.contactLabel.layer.cornerRadius = 10;
                self.callBtn.layer.cornerRadius = 5;
                [self.mapView addAnnotation:ann];}
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"The longitude or latitude is not numeric." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                return;
            }];
            [alertController addAction:yesAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        //set the contact label text.
        storePhone = [NSString stringWithFormat:@"%@",[dicForStoreDetail objectForKey:@"storePhoneNum"]];
        //if the phone number is nil then set the button background and button disable
        if(storePhone == nil){
            self.callBtn.backgroundColor = [UIColor lightGrayColor];
            self.callBtn.enabled = NO;
        }else{
            self.callBtn.enabled = YES;
            self.callBtn.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
        }
        //set store phone label text
        NSString *phoneDetail = [NSString stringWithFormat:@"Phone: %@",storePhone];
        self.contactLabel.text = phoneDetail;
        //get the text from dictionary
        NSString *storeStatus = [NSString stringWithFormat:@"Store Status: %@",[dicForStoreDetail objectForKey:@"storeStatus"]];
        //set store stauts label text
        self.storeStatusLabel.text = storeStatus;
        //set store address label text
        NSString *storeDetail = [NSString stringWithFormat:@"Store Address: %@",[dicForStoreDetail objectForKey:@"street"]];
        self.storeAddressLabel.text = storeDetail;
    */
    NSDictionary *dicForStoreDetail = [dictionary objectForKey:@"store"];
    self.printStatusLabel.text = [NSString stringWithFormat:@"Print Status: %@", [dictionary objectForKey:@"photoStatusCd"]];
    self.storeStatusLabel.text = [NSString stringWithFormat:@"Store Status: %@", [dicForStoreDetail objectForKey:@"storeStatus"]];
    
    [_printStatusLabel setHidden:NO];
    [_storeStatusLabel setHidden:NO];
    [_contactLabel setHidden:NO];
    [_storeAddressLabel setHidden:NO];
    [_callBtn setHidden:NO];
    [_mapView setHidden:NO];
}

#pragma mark - Walgreens API -

// Response with data received successfully.
- (void)walgreensAPIDidSendData:(WalgreensAPI *)sender withData:(NSDictionary *)dictionaryData {
    
    // Turn off the network activity indicator.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    recivedDictionary = dictionaryData;
    
    //Call method requestData
    [self readDataFromDictionary:dictionaryData];
}

// The user is not connected, notify the user by displaying a message on the screen.
- (void)walgreensAPICouldNotConnect:(WalgreensAPI *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You Are Not Connected to the Internet"
                                                                   message:@"This action can't be completed because you are currently offline."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    // Add option to enter device settings.
    [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        return;
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    // Turn off the network activity indicator.
    [_activityIndicator stopAnimating];
    
    // Set labels text
    self.contactLabel.text = @"Phone Number: -";
    self.storeStatusLabel.text = @"Store Status: -";
    self.storeAddressLabel.text = @"Store Address: -";
    self.printStatusLabel.text = @"Print Status: -";
    [_printStatusLabel setHidden:NO];
    [_storeStatusLabel setHidden:NO];
    [_contactLabel setHidden:NO];
    [_storeAddressLabel setHidden:NO];
    [_callBtn setHidden:NO];
    [_mapView setHidden:NO];
    
}

// The server responded with nil data, notify the user that something went wrong and to try again.
- (void)walgreensAPIDidSendNil:(WalgreensAPI *)sender {
    
    [self displayOKAlertwithTitle:@"Something Went Wrong" withMessage:@"Please try again."];
    
    // Set labels text
    self.contactLabel.text = @"Phone: -";
    self.storeStatusLabel.text = @"Store Status: -";
    self.storeAddressLabel.text = @"Store Address: -";
    self.printStatusLabel.text = @"Print Status: -";
    [_printStatusLabel setHidden:NO];
    [_storeStatusLabel setHidden:NO];
    [_contactLabel setHidden:NO];
    [_storeAddressLabel setHidden:NO];
    [_callBtn setHidden:NO];
    [_mapView setHidden:NO];
    
    // Turn off the network activity indicator.
    [_activityIndicator stopAnimating];
}

// The server responded with an error. Depending on the error, display to user what went wrong.
- (void)walgreensAPIDidSendError:(WalgreensAPI *)sender withData:(NSDictionary *)dictionaryData {
    // Turn off the network activity indicator.
    [_activityIndicator stopAnimating];
    
    // Set labels text
    self.contactLabel.text = @"Phone: -";
    self.storeStatusLabel.text = @"Store Status: -";
    self.storeAddressLabel.text = @"Store Address: -";
    self.printStatusLabel.text = @"Print Status: -";
    [_printStatusLabel setHidden:NO];
    [_storeStatusLabel setHidden:NO];
    [_contactLabel setHidden:NO];
    [_storeAddressLabel setHidden:NO];
    [_callBtn setHidden:NO];
    [_mapView setHidden:NO];
    
    if ([[dictionaryData valueForKey:@"errCode"] intValue] >= 506) {
        // Display alert with message set as error description contained in response.
        [self displayOKAlertwithTitle:@"The Server is Temporarily Unavailable" withMessage:[dictionaryData valueForKey:@"errDesc"]];
        
    } else if ([[dictionaryData valueForKey:@"errCode"] intValue] == 504) {
        [self displayOKAlertwithTitle:@"Your Request Timed Out" withMessage:@"Please try again."];
        
    } else {
        [self displayOKAlertwithTitle:@"An Unexpected Error Occured" withMessage:@"Please try again."];
    }
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

@end
