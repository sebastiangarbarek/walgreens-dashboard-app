//
//  StoreTimesTests.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 19/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

// Use 'TEST' as output filter to help with debugging.

#import <XCTest/XCTest.h>
#import "StoreTimes.h"
#import "StoreTimesConstants.h"

@interface StoreTimesTests : XCTestCase
@property StoreTimes *storeTimes;
@end

@implementation StoreTimesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.storeTimes = [[StoreTimes alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTimeZones {
    // All times checked using: https://www.timeanddate.com/worldclock/converter.html
    // Returned date time is in the format: YYYY-MM-dd HH:mm:ss
    
    // The NZ date time to convert to a stores date time.
    NSString *dateTime = @"2017-08-10 13:34:41"; // Daylight saving time in the U.S.
    // The result store.
    NSDictionary *store;
    // The expected date time.
    NSString *expectedDateTime;
    // The result date time.
    NSString *actualDateTime;
    
    // Texas, CE.
    store = [self.storeTimes retrieveStore:@"7005" withDateTime:dateTime];
    expectedDateTime = @"2017-08-09 20:34:41";
    actualDateTime = [store objectForKey:kDateTime];
    XCTAssertEqualObjects(expectedDateTime, actualDateTime);
    
    // California, PA.
    store = [self.storeTimes retrieveStore:@"2306" withDateTime:dateTime];
    expectedDateTime = @"2017-08-09 18:34:41";
    actualDateTime = [store objectForKey:kDateTime];
    XCTAssertEqualObjects(expectedDateTime, actualDateTime);
    
    // Arizona, MO. Special case, Arizona ignores daylight saving time.
    store = [self.storeTimes retrieveStore:@"3630" withDateTime:dateTime];
    expectedDateTime = @"2017-08-09 18:34:41";
    actualDateTime = [store objectForKey:kDateTime];
    XCTAssertEqualObjects(expectedDateTime, actualDateTime);
    
    // Florida, EA.
    store = [self.storeTimes retrieveStore:@"4961" withDateTime:dateTime];
    expectedDateTime = @"2017-08-09 21:34:41";
    actualDateTime = [store objectForKey:kDateTime];
    XCTAssertEqualObjects(expectedDateTime, actualDateTime);
    
    // Puerto Rico, AT.
    store = [self.storeTimes retrieveStore:@"12649" withDateTime:dateTime];
    expectedDateTime = @"2017-08-09 21:34:41";
    actualDateTime = [store objectForKey:kDateTime];
    XCTAssertEqualObjects(expectedDateTime, actualDateTime);
    
    // Hawaii, HA.
    store = [self.storeTimes retrieveStore:@"13838" withDateTime:dateTime];
    expectedDateTime = @"2017-08-09 15:34:41";
    actualDateTime = [store objectForKey:kDateTime];
    XCTAssertEqualObjects(expectedDateTime, actualDateTime);
    
    // Alaska, AL.
    store = [self.storeTimes retrieveStore:@"12679" withDateTime:dateTime];
    expectedDateTime = @"2017-08-09 17:34:41";
    actualDateTime = [store objectForKey:kDateTime];
    XCTAssertEqualObjects(expectedDateTime, actualDateTime);
    
    /*
     List of errors fixed:
     1. Comparing NSNumber to NSString.
     2. Forgot isEqual part in "[[store objectForKey:kTwentyFourHours] isEqualToString:@"Y"]"
     3. storeTimeZoneToId: was returning nil.
     4. Fixed time zone conversion, reason was due to parsing incorrectly, losing time zone data.
     5. Added special case for Arizona, which does not observe DST.
     */
}

- (void)testTimeRetrievingOpenStores {
    [self measureBlock:^{
        // Xcode executes and performs the procedure in this block ten times and returns the average.
        [self.storeTimes retrieveStoresWithDateTime:[DateHelper currentDateAndTime] requestOpen:YES];
    }];
    
    /*
     Results:
     
     Results vary with day and time.
     
     SATURDAY 30/09/2017 5:15 PM
     [StoreTimesTests testTimeRetrievingOpenStores]' measured [Time, seconds] average: 4.169, relative standard deviation: 2.959%, values: [4.402160, 4.106100, 3.995885, 4.141522, 4.156160, 4.319162, 4.296052, 4.058589, 4.059162, 4.160188]
     
     
     */
}

@end
