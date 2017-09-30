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
@property NSArray *preparedOpenClosedStores;

@end

@implementation StoreTimesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.storeTimes = [[StoreTimes alloc] init];
    self.preparedOpenClosedStores = [self.storeTimes retrieveStoresWithDateTime:@"2017-09-30 17:15:00"];
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
    // Xcode executes and performs the procedure in this block ten times and returns the average.
    [self measureBlock:^{
        // Fixed date and time to prevent variation.
        [self.storeTimes retrieveStoresWithDateTime:@"2017-09-30 17:15:00"];
    }];
    
    /*
     Results:
     
     First test:
     [StoreTimesTests testTimeRetrievingOpenStores]' measured [Time, seconds] average: 4.169, relative standard deviation: 2.959%, values: [4.402160, 4.106100, 3.995885, 4.141522, 4.156160, 4.319162, 4.296052, 4.058589, 4.059162, 4.160188]
     
     NSDateFormatter optimization:
     [StoreTimesTests testTimeRetrievingOpenStores]' measured [Time, seconds] average: 3.078, relative standard deviation: 3.212%, values: [3.109066, 2.953633, 3.210005, 2.999866, 3.147465, 3.066309, 2.935010, 3.237892, 3.003315, 3.112947]
     
     Further optimization:
     [StoreTimesTests testTimeRetrievingOpenStores]' measured [Time, seconds] average: 1.647, relative standard deviation: 6.351%, values: [1.563152, 1.820012, 1.498568, 1.601850, 1.832638, 1.561427, 1.657410, 1.697017, 1.584261, 1.656093]
     
     Calender optimization:
     [StoreTimesTests testTimeRetrievingOpenStores]' measured [Time, seconds] average: 1.542, relative standard deviation: 8.090%, values: [1.575420, 1.698424, 1.467607, 1.463339, 1.801212, 1.458536, 1.406584, 1.623095, 1.514912, 1.406236]
     */
}

- (void)testTimeCountingOpenStores {
    [self measureBlock:^{
        int count = 0;
        for (NSDictionary *store in self.preparedOpenClosedStores) {
            if ([[store objectForKey:kOpen] intValue] == 1) {
                count++;
            }
        }
        NSLog(@"%i stores open stores counted.", count);
        
        /*
         Results:
         Average time of 0.003s. Iteration over store array and accessing contained store detail dictionaries has no impact on performance as expected.
         */
    }];
}

@end
