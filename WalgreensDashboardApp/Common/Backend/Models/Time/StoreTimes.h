//
//  StoreTimes.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseManagerApp.h"
#import "DatabaseConstants.h"
#import "DateHelper.h"

@interface StoreTimes : NSObject

/*
 This class can be used to check which stores are open and closed periodically.
 Periodic checking should not be implemented in this class. But by the class that uses this.
 */

typedef NS_ENUM(NSInteger, Day) {
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Sunday
};

/*!Retrieves a store, processes and updates its physical status and returns the result.
 Current date and time is retrieved each call to this method.
 * \returns Relevant store details with an added entry indicating if the store is currently open or closed.
 Or nil if the store does not exist or hours data is not available for it.
 */
- (NSDictionary *)retrieveStore:(NSString *)storeNumber;

@end
