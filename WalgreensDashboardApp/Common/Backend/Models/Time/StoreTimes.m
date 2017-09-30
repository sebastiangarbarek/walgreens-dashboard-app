//
//  StoreTimes.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreTimes.h"

/*
 Apple recommends to cache formatters for efficiency: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html#//apple_ref/doc/uid/TP40002369-SW10 see "Cache Formatters for Efficiency".
 */
static NSDateFormatter *sDateFormatter = nil;

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

- (NSDictionary *)retrieveStore:(NSString *)storeNumber withDateTime:(NSString *)dateTime {
    NSDictionary *store = [self findStore:storeNumber];
    if ([self isStoreOpen:store withDateTime:dateTime])
        [store setValue:@YES forKey:kOpen];
    else
        [store setValue:@NO forKey:kOpen];
    return store;
    /* Can add top to bottom overlay with alpha on MapView to show area of open stores.
     This will be helpful in identifying stores that aren't 24/7, and also helpful in 
     identifying where the sun is on the U.S.
     */
}

- (NSArray *)retrieveStoresWithDateTime:(NSString *)dateTime {
    NSMutableArray *results = [NSMutableArray new];
    for (NSDictionary *store in stores) {
        NSDictionary *storeResult = [self queryStore:store withDateTime:dateTime];
        [results addObject:storeResult];
    }
    return results;
}

- (NSArray *)retrieveStoresWithDateTime:(NSString *)dateTime requestOpen:(BOOL)requestOpen {
    NSMutableArray *results = [NSMutableArray new];
    for (NSDictionary *store in stores) {
        NSDictionary *storeResult = [self queryStore:store withDateTime:dateTime];
        if ([[storeResult objectForKey:kOpen] intValue] == 1 && requestOpen) {
            [results addObject:storeResult];
        } else if ([[storeResult objectForKey:kOpen] intValue] == 0 && !requestOpen) {
            [results addObject:storeResult];
        }
    }
    return results;
}

- (NSDictionary *)queryStore:(NSDictionary *)store withDateTime:(NSString *)dateTime {
    if ([self isStoreOpen:store withDateTime:dateTime])
        [store setValue:@YES forKey:kOpen];
    else
        [store setValue:@NO forKey:kOpen];
    return store;
}

/*!Helper method used to check if a store is currently open,
 given the provided date and time, store hours and timezone.
 * \returns YES if the store is open or NO at the given time.
 */
- (BOOL)isStoreOpen:(NSDictionary *)store withDateTime:(NSString *)dateTime {
    if ([[store objectForKey:kTwentyFourHours] isEqualToString:@"Y"])
        // The store is 24/7.
        return YES;
    else {
        /* 
         Prepare current date and time.
         */
        
        if (sDateFormatter == nil) {
            // Alloc and init static formatter if not allocated.
            sDateFormatter = [[NSDateFormatter alloc] init];
        }
        
        [sDateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        [sDateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"Pacific/Auckland"]];
        NSDate *aucklandDateTime = [sDateFormatter dateFromString:dateTime];
        
        /*
         Convert NZ date and time to stores date and time with time zone.
         */
        
        NSDate *storeDateTime;
        // Get stores time zone code.
        NSString *storesTimeZone = [store objectForKey:kTimeZone];
        NSString *timeZoneName = [self storeTimeZoneToId:storesTimeZone];
        
        if ([[store objectForKey:kState] isEqualToString:@"AZ"]) {
            // Arizona is a special case. Only state where DST is not observed.
            [sDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
            [sDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:-3600*7]]; // GMT-7.
        } else {
            [sDateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:timeZoneName]];
        }
        
        NSString *storeDateTimeString = [sDateFormatter stringFromDate:aucklandDateTime];
        storeDateTime = [sDateFormatter dateFromString:storeDateTimeString];
        
        // Store date and time in result.
        [store setValue:[sDateFormatter stringFromDate:storeDateTime] forKey:kDateTime];
        
        /*
         Check if the store is open during NZ time.
         */
        
        // Get weekday for stores time zone, as it could be different to user location.
        Day day = [self timeZonesWeekDay:storeDateTime];
        
        // Get store times for weekday.
        NSArray *storeTimes = [self openCloseTimeWithDay:day store:store];
        if ([storeTimes[0] isEqualToString:@"CLOSED"] || [storeTimes[1] isEqualToString:@"CLOSED"]) {
            return NO;
        }
        
        // Get store date time string using time zone.
        storeDateTimeString = [sDateFormatter stringFromDate:storeDateTime];
        
        // Prepare the formatter to parse 24 hour time.
        sDateFormatter = [[NSDateFormatter alloc] init];
        [sDateFormatter setDateFormat:@"HH:mm:ss"];
        
        // Substring the time.
        storeDateTimeString = [storeDateTimeString substringFromIndex:11];
        NSDate *currentTime24 = [sDateFormatter dateFromString:storeDateTimeString];
        
        // Convert 24 hour time to 12 hour time.
        [sDateFormatter setDateFormat:@"hh:mma"];
        NSString *currentTime12 = [sDateFormatter stringFromDate:currentTime24];
        
        long locationTime = [self minutesSinceMidnight:[sDateFormatter dateFromString:currentTime12]];
        long openTime = [self minutesSinceMidnight:[sDateFormatter dateFromString:storeTimes[0]]];
        long closeTime = [self minutesSinceMidnight:[sDateFormatter dateFromString:storeTimes[1]]];
        
        if (locationTime < closeTime && locationTime > openTime) {
            /*
            NSLog(@"%@ is between %@ and %@",
                  [dateFormatter stringFromDate:[dateFormatter dateFromString:currentTime12]],
                  [dateFormatter stringFromDate:[dateFormatter dateFromString:storeTimes[0]]],
                  [dateFormatter stringFromDate:[dateFormatter dateFromString:storeTimes[1]]]);
             */
            return YES;
        } else {
            /*
            NSLog(@"%@ is not between %@ and %@",
                  [dateFormatter stringFromDate:[dateFormatter dateFromString:currentTime12]],
                  [dateFormatter stringFromDate:[dateFormatter dateFromString:storeTimes[0]]],
                  [dateFormatter stringFromDate:[dateFormatter dateFromString:storeTimes[1]]]);
             */
            return NO;
        }
    }
}

- (long)minutesSinceMidnight:(NSDate *)date {
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    unsigned unitFlags =  NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:date];
    return 60 * [components hour] + [components minute];
}

- (long)secondsToNextHour {
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    const unsigned units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents* components = [gregorian components:units fromDate:[NSDate new]];
    
    long hour = [components hour];
    long minute  = [components minute];
    long second  = [components second];
    
    long now = ((hour * 60) + minute) * 60 + second;
    
    // Add one hour.
    components.hour += 1;
    components.minute = 0;
    components.second = 0;
    hour = [components hour];
    minute  = [components minute];
    second  = [components second];
    
    self.updateHour = ((hour * 60) + minute) * 60 + second;
    
    long seconds = self.updateHour - now;
    
    // Uncomment to debug.
    // NSLog(@"Seconds until next hour: %li", seconds);
    
    return seconds;
}

- (BOOL)hasUpdateHourPassed {
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    const unsigned units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents* components = [gregorian components:units fromDate:[NSDate new]];
    
    long hour = [components hour];
    long minute  = [components minute];
    long second  = [components second];
    
    long now = ((hour * 60) + minute) * 60 + second;
    
    if (self.updateHour - now <= 0) {
        return YES;
    }
    
    return NO;
}

- (NSString *)storeTimeZoneToId:(NSString *)timeZone {
    // Uncomment to print all time zone IDs.
    // NSLog(@"%@", [NSTimeZone knownTimeZoneNames]);
    
    NSString __block *timeZoneName;
    
    typedef void (^CaseBlock)();
    
    // Objective-C cannot perform a switch on NSString... We must improvise.
    NSDictionary *stringSwitchCase = @{
                                       // United States has four major timezones.
                                       @"EA": ^{timeZoneName = @"America/New_York";}, // Eastern (EDT).
                                       @"CE": ^{timeZoneName = @"America/Chicago";}, // Central (CST).
                                       @"MO": ^{timeZoneName = @"America/Denver";}, // Mountain (MST).
                                       @"PA": ^{timeZoneName = @"America/Los_Angeles";}, // Pacific (PDT).
                                       @"AT": ^{timeZoneName = @"America/Puerto_Rico";}, // Atlantic - Puerto Rico.
                                       @"HA": ^{timeZoneName = @"Pacific/Honolulu";}, // Hawaii (HST).
                                       @"AL": ^{timeZoneName = @"America/Anchorage";}}; // Alaska.
    // Reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    // and
    // NSLog(@"%@", [NSTimeZone abbreviationDictionary]);
    
    CaseBlock block = stringSwitchCase[timeZone];
    // Execute block if retrieved successfully or throw an exception as default.
    if (block) block(); else { @throw [NSException exceptionWithName:NSInvalidArgumentException
                                                              reason:[NSString stringWithFormat:@"%@ expected U.S. time zone", NSStringFromSelector(_cmd)]
                                                            userInfo:nil]; }
    
    // All possible U.S. timezones are above. The exception will not be thrown unless the time zone abbreviation is mistyped by Walgreens, or outside U.S.
    return timeZoneName;
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
            return @[[store objectForKey:kSatOpen], [store objectForKey:kSatClose]];
        case Sunday:
            return @[[store objectForKey:kSunOpen], [store objectForKey:kSunClose]];
    }
}

/*!Given the way the results from the database are currently returned,
 we have to iterate an array of 7,000+ results, checking each dictionary for the store number.
 If speed is an issue, this can be made faster if a dictionary was used in place of the array.
 However, only if the returned rows have a guaranteed unique identifier.
 * \returns The store or nil if not found.
 */
- (NSDictionary *)findStore:(NSString *)storeNumber {
    for (NSDictionary *store in stores) {
        if ([[[store objectForKey:kStoreNum] stringValue] isEqualToString:storeNumber])
            return store;
    }
    return nil;
}

@end
