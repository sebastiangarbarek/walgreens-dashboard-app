//
//  TemporaryData.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 9/05/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

@interface TemporaryData : NSObject

/*
 The store numbers array is shared across the menu and store list
 view controllers. Use of this model avoids having to retrieve the
 store list from the server every time. The store list on the
 server doesn't update often as it only gets updated when Walgreens
 launch a new store in the U.S. 
 
 The user is able to manually refresh the store list by using the
 refresh button on the navigation bar.
 */
@property (strong, nonatomic) NSArray *storeNumbers;

// Uses the singleton pattern.
+ (TemporaryData *)sharedInstance;

@end
