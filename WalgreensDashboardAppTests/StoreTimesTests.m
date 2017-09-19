//
//  StoreTimesTests.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 19/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StoreTimes.h"

@interface StoreTimes (Testing)

// Private methods.
- (NSString *)storeTimeZoneToId:(NSString *)timeZone;
- (NSDate *)storeDateTimeWithTimeZoneName:(NSString *)timeZoneName;
/* Note that typically only public methods should be tested as they use the private methods.
 However, this was done by TDD, and the public method was not complete.
 */

@end

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
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
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
