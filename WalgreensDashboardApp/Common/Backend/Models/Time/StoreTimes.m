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
static NSDateFormatter *sNzDateFormatter = nil;
static NSDateFormatter *sAzDateFormatter = nil;
static NSDateFormatter *sEaDateFormatter = nil;
static NSDateFormatter *sCeDateFormatter = nil;
static NSDateFormatter *sMoDateFormatter = nil;
static NSDateFormatter *sPaDateFormatter = nil;
static NSDateFormatter *sAtDateFormatter = nil;
static NSDateFormatter *sHaDateFormatter = nil;
static NSDateFormatter *sAlDateFormatter = nil;
static NSDateFormatter *s12DateFormatter = nil;
static NSDateFormatter *s24DateFormatter = nil;
static NSCalendar *sCalender = nil;

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
         Prepare NZ date and time.
         */
        
        if (sNzDateFormatter == nil) {
            // Alloc and init static formatter if not allocated.
            sNzDateFormatter = [[NSDateFormatter alloc] init];
            [sNzDateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            [sNzDateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"Pacific/Auckland"]];
        }
        
        NSDate *aucklandDateTime = [sNzDateFormatter dateFromString:dateTime];
        
        /*
         Convert NZ date and time to stores date and time with time zone.
         */
        
        NSDate *storeDateTime;
        NSDateFormatter *dateFormatter;
        
        // Get stores time zone code.
        NSString *storesTimeZone = [store objectForKey:kTimeZone];
        
        if ([[store objectForKey:kState] isEqualToString:@"AZ"]) {
            // Arizona is a special case. Only state where DST is not observed.
            if (sAzDateFormatter == nil) {
                sAzDateFormatter = [[NSDateFormatter alloc] init];
                [sAzDateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                [sAzDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
                [sAzDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:-3600*7]]; // GMT-7.
            }
            dateFormatter = sAzDateFormatter;
        } else {
            dateFormatter = [self storeTimeZoneToDf:storesTimeZone];
        }
        
        NSString *storeDateTimeString = [dateFormatter stringFromDate:aucklandDateTime];
        storeDateTime = [dateFormatter dateFromString:storeDateTimeString];
        
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
        storeDateTimeString = [dateFormatter stringFromDate:storeDateTime];
        
        // Prepare the formatter to parse 24 hour time.
        if (s24DateFormatter == nil) {
            s24DateFormatter = [[NSDateFormatter alloc] init];
            [s24DateFormatter setDateFormat:@"HH:mm:ss"];
        }

        // Substring the time.
        storeDateTimeString = [storeDateTimeString substringFromIndex:11];
        NSDate *currentTime24 = [s24DateFormatter dateFromString:storeDateTimeString];
        
        // Convert 24 hour time to 12 hour time.
        if (s12DateFormatter == nil) {
            s12DateFormatter = [[NSDateFormatter alloc] init];
            [s12DateFormatter setDateFormat:@"hh:mma"];
        }
        
        NSString *currentTime12 = [s12DateFormatter stringFromDate:currentTime24];
        // Store time in result.
        [store setValue:currentTime12 forKey:kTime];
        
        long locationTime = [self minutesSinceMidnight:[s12DateFormatter dateFromString:currentTime12]];
        long openTime = [self minutesSinceMidnight:[s12DateFormatter dateFromString:storeTimes[0]]];
        long closeTime = [self minutesSinceMidnight:[s12DateFormatter dateFromString:storeTimes[1]]];
        
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
    if (sCalender == nil) {
        sCalender = [NSCalendar currentCalendar];
    }
    
    unsigned unitFlags =  NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [sCalender components:unitFlags fromDate:date];
    return 60 * [components hour] + [components minute];
}

- (long)secondsToNextHour {
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    const unsigned units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents* components = [calender components:units fromDate:[NSDate new]];
    
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
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    const unsigned units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents* components = [calender components:units fromDate:[NSDate new]];
    
    long hour = [components hour];
    long minute  = [components minute];
    long second  = [components second];
    
    long now = ((hour * 60) + minute) * 60 + second;
    
    if (self.updateHour - now <= 0) {
        return YES;
    }
    
    return NO;
}

- (NSDateFormatter *)storeTimeZoneToDf:(NSString *)timeZone {
    // Uncomment to print all time zone IDs.
    // NSLog(@"%@", [NSTimeZone knownTimeZoneNames]);
    
    NSDateFormatter __block *dateFormatter;
    
    typedef void (^CaseBlock)();
    
    // Objective-C cannot perform a switch on NSString... We must improvise.
    NSDictionary *stringSwitchCase = @{
                                       // United States has four major timezones.
                                       @"EA": ^{
                                           // Eastern (EDT).
                                           if (sEaDateFormatter == nil) {
                                               sEaDateFormatter = [[NSDateFormatter alloc] init];
                                               [sEaDateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                                               [sEaDateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"America/New_York"]];
                                           }
                                           dateFormatter = sEaDateFormatter;
                                       },
                                       @"CE": ^{
                                           // Central (CST).
                                           if (sCeDateFormatter == nil) {
                                               sCeDateFormatter = [[NSDateFormatter alloc] init];
                                               [sCeDateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                                               [sCeDateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"America/Chicago"]];
                                           }
                                           dateFormatter = sCeDateFormatter;
                                       },
                                       @"MO": ^{
                                           // Mountain (MST).
                                           if (sMoDateFormatter == nil) {
                                               sMoDateFormatter = [[NSDateFormatter alloc] init];
                                               [sMoDateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                                               [sMoDateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"America/Denver"]];
                                           }
                                           dateFormatter = sMoDateFormatter;
                                       },
                                       @"PA": ^{
                                           // Pacific (PDT).
                                           if (sPaDateFormatter == nil) {
                                               sPaDateFormatter = [[NSDateFormatter alloc] init];
                                               [sPaDateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                                               [sPaDateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"America/Los_Angeles"]];
                                           }
                                           dateFormatter = sPaDateFormatter;
                                       },
                                       @"AT": ^{
                                           // Atlantic - Puerto Rico.
                                           if (sAtDateFormatter == nil) {
                                               sAtDateFormatter = [[NSDateFormatter alloc] init];
                                               [sAtDateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                                               [sAtDateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"America/Puerto_Rico"]];
                                           }
                                           dateFormatter = sAtDateFormatter;
                                       },
                                       @"HA": ^{
                                           // Hawaii (HST).
                                           if (sHaDateFormatter == nil) {
                                               sHaDateFormatter = [[NSDateFormatter alloc] init];
                                               [sHaDateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                                               [sHaDateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"Pacific/Honolulu"]];
                                           }
                                           dateFormatter = sHaDateFormatter;
                                       },
                                       @"AL": ^{
                                           // Alaska.
                                           if (sAlDateFormatter == nil) {
                                               sAlDateFormatter = [[NSDateFormatter alloc] init];
                                               [sAlDateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                                               [sAlDateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"America/Anchorage"]];
                                           }
                                           dateFormatter = sAlDateFormatter;
                                       }};
    // Reference: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    // and
    // NSLog(@"%@", [NSTimeZone abbreviationDictionary]);
    
    CaseBlock block = stringSwitchCase[timeZone];
    // Execute block if retrieved successfully or throw an exception as default.
    if (block) block(); else { @throw [NSException exceptionWithName:NSInvalidArgumentException
                                                              reason:[NSString stringWithFormat:@"%@ expected U.S. time zone", NSStringFromSelector(_cmd)]
                                                            userInfo:nil]; }
    
    // All possible U.S. timezones are above. The exception will not be thrown unless the time zone abbreviation is mistyped by Walgreens, or outside U.S.
    return dateFormatter;
}

- (enum Day)timeZonesWeekDay:(NSDate *)storeDateTime {
    if (sCalender == nil) {
        sCalender = [NSCalendar currentCalendar];
    }
    
    return [sCalender component:NSCalendarUnitWeekday fromDate:storeDateTime];
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
