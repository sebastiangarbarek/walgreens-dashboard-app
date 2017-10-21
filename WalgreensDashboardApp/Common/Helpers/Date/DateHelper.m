//
//  DateHelper.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 28/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+ (NSString *)stringWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateWithString:(NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    return [dateFormatter dateFromString:date];
}

+ (NSString *)currentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)currentDateAndTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
