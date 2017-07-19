//
//  WalgreensAPI.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 8/05/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WalgreensAPI.h"

static NSString *const apiKey = @"HaVvNTNGKqsZuZR8ARAC0q3rvAeuam5P";
static NSString *const affId = @"photoapi";

@implementation WalgreensAPI {
    // The dispatch group to track responses when checking status of servers.
    dispatch_group_t dispatchGroup;
    // If true sets the status of the service for the view to display.
    bool checkingStatus;
    // To hold the service statuses.
    NSDictionary *serviceStatuses;
}

@synthesize delegate;

#pragma mark - Walgreens API Services -

- (void)requestStoreNumbers {
    // Create request data.
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    [requestDictionary setValue:apiKey forKey:@"apiKey"];
    [requestDictionary setValue:affId forKey:@"affId"];
    [requestDictionary setValue:@"storeNumber" forKey:@"act"];
    [requestDictionary setValue:@"iPhone,10.3" forKey:@"devinf"];
    [requestDictionary setValue:@"1.00" forKey:@"appver"];
    
    // Convert dictionary to JSON representation for HTTP body.
    NSData *jsonRequestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    // Setup HTTP request.
    NSURL *requestURL = [NSURL URLWithString:@"https://services-qa.walgreens.com/api/util/storenumber"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:requestURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonRequestData];
    
    [self createSessionWithRequest:request forService:@"Store Locator API"];
}

- (void)requestStoreDetails:(NSString *)selectedStoreNumber {
    // Create request data.
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    [requestDictionary setValue:apiKey forKey:@"apiKey"];
    [requestDictionary setValue:affId forKey:@"affId"];
    [requestDictionary setValue:selectedStoreNumber forKey:@"storeNo"];
    [requestDictionary setValue:@"storeDtl" forKey:@"act"];
    [requestDictionary setValue:@"storeDtlJSON" forKey:@"view"];
    [requestDictionary setValue:@"iPhone,10.3" forKey:@"devinf"];
    [requestDictionary setValue:@"1.00" forKey:@"appver"];
    
    // Convert dictionary to JSON representation for HTTP body.
    NSData *jsonRequestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    // Setup HTTP request.
    NSURL *requestURL = [NSURL URLWithString:@"https://services-qa.walgreens.com/api/stores/details"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:requestURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonRequestData];
    
    [self createSessionWithRequest:request forService:@"Store Locator API"];
}

- (void)requestPriceList {
    // Create request data.
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    [requestDictionary setValue:apiKey forKey:@"apiKey"];
    [requestDictionary setValue:affId forKey:@"affId"];
    [requestDictionary setValue:@"" forKey:@"productGroupId"];
    [requestDictionary setValue:@"getphotoprods" forKey:@"act"];
    [requestDictionary setValue:@"iPhone,10.3" forKey:@"devinf"];
    [requestDictionary setValue:@"1.00" forKey:@"appver"];
    
    // Convert dictionary to JSON representation for HTTP body.
    NSData *jsonRequestData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    // Setup HTTP request.
    NSURL *requestURL = [NSURL URLWithString:@"https://services-qa.walgreens.com/api/photo/products/v3"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:requestURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonRequestData];
    
    [self createSessionWithRequest:request forService:@"Photo Print API"];
}

- (void)checkStatusOfServices {
    checkingStatus = true;
    serviceStatuses = [NSMutableDictionary dictionary];
    
    // Use a dispatch group to collect multiple responses before handling.
    dispatchGroup = dispatch_group_create();
    
    // Check status of store locator service.
    dispatch_group_enter(dispatchGroup);
    [self requestStoreNumbers];
    
    // Check status of photo prints service.
    dispatch_group_enter(dispatchGroup);
    [self requestPriceList];
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^ {
        checkingStatus = false;
        [self.delegate walgreensAPIStatus:self withStatuses:serviceStatuses];
    });
}

#pragma mark - Helper Methods -

- (void)createSessionWithRequest:(NSMutableURLRequest *)request forService:(NSString *)service {
    // Send request and handle response.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *responseData, NSURLResponse *responseURL, NSError *sessionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // Convert the JSON data to dictionary.
            NSDictionary *responseDictionary = nil;
            if (responseData != nil) {
                // For debugging the response.
                id prettyPrintedResponse = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                NSLog(@"Response:\n%@", [[NSString alloc] initWithString:[prettyPrintedResponse description]]);
                
                responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            }
            
            /*
             For checking the status of the servers there will be multiple requests fired at once to check the different services.
             iOS ignores alerts when there is an alert already displaying so we do not have to worry if the method that
             tells the controller that the user is not connected is called more than once for example. This is safe only
             in this situation, as UI elements are guaranteed to only be updated once by the main thread using
             the dispatch group in the check server status method.
             */
            if (sessionError != nil) {
                // The user is not connected to the internet.
                [self setServiceStatusFor:service withStatus:@"Offline"];
                
                [self.delegate walgreensAPICouldNotConnect:self];
            } else {
                if (responseDictionary == nil) {
                    [self setServiceStatusFor:service withStatus:@"Offline"];
                    
                    // There was no JSON data in the response.
                    [self.delegate walgreensAPIDidSendNil:self];
                } else if ([[responseDictionary valueForKey:@"errCode"] intValue] != 0) { // intValue returns 0 if nil.
                    // The server is offline.
                    [self setServiceStatusFor:service withStatus:@"Offline"];
                    
                    // The response contained an error code.
                    [self.delegate walgreensAPIDidSendError:self withData:responseDictionary];
                } else {
                    // The server is online.
                    [self setServiceStatusFor:service withStatus:@"Online"];
                    
                    // We are checking the status of the service and do not want to handle the data.
                    if (!checkingStatus) {
                        // The response was successful.
                        [self.delegate walgreensAPIDidSendData:self withData:responseDictionary];
                    }
                }
            }
        });
    }] resume];
}

- (void)setServiceStatusFor:(NSString *)service withStatus:(NSString *)status {
    // Ignored if we are not checking for the status of this service.
    if (checkingStatus) {
        // Notify as completed.
        dispatch_group_leave(dispatchGroup);
        
        // Set the status of the service as offline or online.
        [serviceStatuses setValue:status forKey:service];
    }
}

@end
