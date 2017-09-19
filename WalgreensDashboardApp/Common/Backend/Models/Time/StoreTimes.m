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
        // Get stores time zone code.
        NSString *storesTimeZone = [store objectForKey:kTimeZone];
        NSString *timeZoneName = [self storeTimeZoneToId:storesTimeZone];
        
        // Get current date and time.
        NSString *currentDateTime = [DateHelper currentDateAndTime];
        
        // Convert current date and time to stores date and time with time zone.
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZoneName]];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate *storeDateTime = [dateFormatter dateFromString:currentDateTime];
        
        // Store date and time in result.
        [store setValue:[dateFormatter stringFromDate:storeDateTime] forKey:@"currentDateTime"];
        
        // Get weekday for stores time zone, as it could be different to user location.
        Day day = [self timeZonesWeekDay:storeDateTime];
        
        // Get store times for weekday.
        NSArray *storeTimes = [self openCloseTimeWithDay:day store:store];
        
        // Check if store date time within store time.
        [dateFormatter setDateFormat:@"hh:mma"];
        NSDate *currentTime = [dateFormatter dateFromString:currentDateTime];
        NSDate *openTime = [dateFormatter dateFromString:storeTimes[0]];
        NSDate *closeTime = [dateFormatter dateFromString:storeTimes[1]];
        
        switch ([currentTime compare:closeTime]) {
            case NSOrderedAscending:
                // date1 > date2
                return NO;
            case NSOrderedDescending: {
                // date1 < date2
                switch ([currentTime compare:openTime]) {
                    case NSOrderedAscending:
                        // date1 > date2
                        return YES;
                    case NSOrderedDescending:
                        // date1 < date2
                        return NO;
                    case NSOrderedSame:
                        // date1 = date2
                        return YES;
                }
            }
            case NSOrderedSame:
                // date1 = date2
                return NO;
        }
    }
}

- (NSString *)storeTimeZoneToId:(NSString *)timeZone {
    // Uncomment to print all time zone IDs.
    // NSLog(@"%@", [NSTimeZone knownTimeZoneNames]);
    
    typedef void (^CaseBlock)();
    
    // Objective-C cannot perform a switch on NSString... We must improvise.
    NSDictionary *stringSwitchCase = @{
                                       @"EA": ^{return @"America/New_York";}, // Eastern.
                                       @"CE": ^{return @"America/Chicago";}, // Central.
                                       @"MO": ^{return @"America/Denver";}, // Mountain.
                                       @"PA": ^{return @"America/Los_Angeles";}, // Pacific.
                                       @"AT": ^{return @"America/Puerto_Rico";}, // Atlantic - Puerto Rico.
                                       @"HA": ^{return @"Pacific/Honolulu";}, // Hawaii.
                                       @"AL": ^{return @"America/Anchorage";}}; // Alaska.
    // Reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    // No default...
    
    CaseBlock block = stringSwitchCase[timeZone];
    // Execute block if retrieved successfully or throw an exception as default.
    if (block) block(); else { @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                                              reason:[NSString stringWithFormat:@"%@ expected U.S. time zone", NSStringFromSelector(_cmd)]
                                                            userInfo:nil]; }
    
    // All possible U.S. timezones are above. The exception will not be thrown unless the time zone abbreviation is mistyped by Walgreens, or outside U.S.
    return nil;
}

- (enum Day)timeZonesWeekDay:(NSDate *)storeDateTime {
    return [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday
                                          fromDate:storeDateTime];
}

- (NSArray *)openCloseTimeWithDay:(enum Day)day store:(NSDictionary *)store {
    // Where array[0] is open time and array[1] is close time.
    switch (day) {
        case Monday:
            return @[[store objectForKey:kMonOpen], [store objectForKey:kMonClose]];
        case Tuesday:
            return @[[store objectForKey:kTueOpen], [store objectForKey:kTueClose]];
        case Wednesday:
            return @[[store objectForKey:kWedOpen], [store objectForKey:kWedClose]];
        case Thursday:
            return @[[store objectForKey:kThuOpen], [store objectForKey:kThuClose]];
        case Friday:
            return @[[store objectForKey:kFriOpen], [store objectForKey:kFriClose]];
        case Saturday:
            return @[[store objectForKey:kSatOpen], [store objectForKey:kSunClose]];
        case Sunday:
            return @[[store objectForKey:kSunOpen], [store objectForKey:kSunClose]];
    }
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
