//
//  StoreDetailTests.m
//  WalgreensDashboardAppTests
//
//  Created by Nan on 2017/5/7.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "StoreDetailViewController.h"

@interface StoreDetailTests : XCTestCase

@property (nonatomic, strong) StoreDetailViewController *sdvc;

@end

@implementation StoreDetailTests

- (void)setUp {
    [super setUp];
    self.sdvc = [[StoreDetailViewController alloc] init];
}

- (void)tearDown {
    self.sdvc = nil;
    [super tearDown];
}

- (void) testPhoneNumber {
    BOOL isPhoneNumber = [self.sdvc isPhoneNumber:@"288925a"];
    XCTAssertFalse(isPhoneNumber, @"Phone number is invalid.");
    
    isPhoneNumber = [self.sdvc isPhoneNumber:@"2889256"];
    XCTAssertTrue(isPhoneNumber, @"Phone number is valid.");
}

- (void) testCoordinate {
    BOOL isCoordinate = [self.sdvc isCoordinate:@"d21-.d23"];
    XCTAssertFalse(isCoordinate, @"Coordinate is invalid.");
    
    isCoordinate = [self.sdvc isCoordinate:@"-12.23123"];
    XCTAssertTrue(isCoordinate, @"Coordinate is valid.");
    
    isCoordinate = [self.sdvc isCoordinate:@"33.3023"];
    XCTAssertTrue(isCoordinate, @"Coordinate is valid.");
}

-(void) testValidCoordinate {
    XCTAssertFalse([self.sdvc isCoordinateValid:85.2332 :120.232], @"Coordinate is invalid.");
    XCTAssertTrue([self.sdvc isCoordinateValid:92.853 :120.123], @"Coordinate is valid.");
    XCTAssertTrue([self.sdvc isCoordinateValid:-93.3234 :120.256], @"Coordinate is valid.");
    XCTAssertTrue([self.sdvc isCoordinateValid:85.232 :190.023], @"Coordinate is valid.");
    XCTAssertTrue([self.sdvc isCoordinateValid:85.23 :-190.234], @"Coordinate is valid.");
}

@end
