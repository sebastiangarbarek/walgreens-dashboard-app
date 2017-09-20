//
//  StoreTimesTests.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 19/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

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
    NSString *dateTime = @"2017-08-10 13:34:41";
    // The result store.
    NSDictionary *store;
    // The expected date time.
    NSString *expectedDateTime;
    // The result date time.
    NSString *actualDateTime;
    
    // Houston, Texas.
    store = [self.storeTimes retrieveStore:@"7005" withDateTime:dateTime];
    expectedDateTime = @"2017-08-09 20:34:41";
    actualDateTime = [store objectForKey:kDateTime];
    NSLog(@"[TEST] Asserting equal (%@, %@)...", expectedDateTime, actualDateTime);
    XCTAssertEqual(expectedDateTime, actualDateTime);
    
    /*
     List of errors fixed:
     1. Comparing NSNumber to NSString.
     */
}

/*
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
*/

@end
