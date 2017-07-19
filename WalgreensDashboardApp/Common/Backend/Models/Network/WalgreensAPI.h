//
//  WalgreensAPI.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 8/05/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

@class WalgreensAPI;

/*
 This delegate is to be used in all view controller classes that use the Walgreens API.
 Each view controller should implement the methods of this delegate to handle all
 possible responses from a request. For example, the Walgreens server could be 
 down and the view controller should handle this type of response for the view.
 
 The Walgreens API class handles nil checking and only sends data that is not nil.
 However, it is up to the view controller to check the data it receives. For
 example, checking if the phone number in a response received does not contain any letters.
 */
@protocol WalgreensAPIDelegate <NSObject>

// A response was successfully received with data.
@required
- (void)walgreensAPIDidSendData:(WalgreensAPI *)sender withData:(NSDictionary *)dictionaryData;

// The user is not connected to the internet.
@required
- (void)walgreensAPICouldNotConnect:(WalgreensAPI *)sender;

// There was no data in the response.
@required
- (void)walgreensAPIDidSendNil:(WalgreensAPI *)sender;

// A response was received containing a server error.
@required
- (void)walgreensAPIDidSendError:(WalgreensAPI *)sender withData:(NSDictionary *)dictionaryData;

// Passes the status of Walgreens API services.
@optional
- (void)walgreensAPIStatus:(WalgreensAPI *)sender withStatuses:(NSDictionary *)serviceStatuses;

@end

@interface WalgreensAPI : NSObject

@property (nonatomic, weak) id <WalgreensAPIDelegate> delegate;

- (void)requestStoreNumbers;
- (void)requestStoreDetails:(NSString *)selectedStoreNumber;
- (void)requestPriceList;
- (void)checkStatusOfServices;

@end
