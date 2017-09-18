//
//  StoreTimes.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreTimes.h"

@interface StoreTimes () {
    // Objects should not access the data structures in this class directly.
    
    /* An array of stores retrieved from the database on init.
     The stores in this array:
     1. Are print stores.
     2. Have store hours available.
     3. Have a non-null timezone value.
     */
    NSArray *stores;
    
    DatabaseManagerApp *databaseManagerApp;
}

@end

@implementation StoreTimes 

- (instancetype)init {
    if (self = [super init]) {
        [self createDatabaseConnection];
        [self loadData];
    }
    return self;
}

- (void)createDatabaseConnection {
    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    [databaseManagerApp openCreateDatabase];
}

- (void)loadData {
    stores = [databaseManagerApp.selectCommands selectAllPrintStoresAndHours];
}

- (NSDictionary *)retrieveStore:(NSString *)storeNumber {
    NSDictionary *store = [self findStore:storeNumber];
    if ([self isStoreOpen:store])
        [store setValue:@YES forKey:@"currentlyOpen"];
    else
        [store setValue:@NO forKey:@"currentlyOpen"];
    return store;
    /* Can add top to bottom overlay with alpha on MapView to show area of open stores.
     This will be helpful in identifying stores that aren't 24/7, and also helpful in 
     identifying where the sun is on the U.S.
     */
}

/*!Private helper method used to check if a store is currently open,
 given the current date and time, store hours and timezone.
 * \returns YES if the store is currently open or NO.
 */
- (BOOL)isStoreOpen:(NSDictionary *)store {
    if ([store objectForKey:kTwentyFourHours])
        // The store is 24/7.
        return YES;
    else {
        // Get current date and time.
        NSString *currentDateTime = [DateHelper currentDateAndTime];
        
        // Get stores timezone code.
        NSString *storesTimeZone = [store objectForKey:kTimeZone];
        NSString *timeZoneName = [self storeTimeZoneToId:storesTimeZone];
        
        // Convert current date and time to stores timezone.
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZoneName]];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *storeDateTime = [dateFormatter dateFromString:currentDateTime];
        
        // Get weekday for stores timezone, as it could be different to user location.
        Day day = [self timeZonesWeekDay:storeDateTime];
        
        // Get store times for weekday.
        NSArray *storeTimes = [self openCloseTimeWithDay:day store:store];
        
        // Check if store date time within store time.
        
    }
}

- (NSString *)storeTimeZoneToId:(NSString *)timeZone {
    // Uncomment to print all time zone IDs.
    // NSLog(@"%@", [NSTimeZone knownTimeZoneNames]);
}

- (enum Day)timeZonesWeekDay:(NSDate *)storeDateTime {
    
}

- (NSArray *)openCloseTimeWithDay:(enum Day)day store:(NSDictionary *)store {
    
}

/*!Given the way the results from the database are currently returned,
 we have to iterate an array of 7,000+ results, checking each dictionary for the store number.
 If speed is an issue, this can be made faster if a dictionary was used in place of the array.
 However, only if the returned rows have a guaranteed unique identifier.
 * \returns YES if the store is currently open or NO.
 */
- (NSDictionary *)findStore:(NSString *)storeNumber {
    for (NSDictionary *store in stores) {
        if ([[store objectForKey:kStoreNum] isEqualToString:storeNumber])
            return store;
    }
    return nil;
}

@end
