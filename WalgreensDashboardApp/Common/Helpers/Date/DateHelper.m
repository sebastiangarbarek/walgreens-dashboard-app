//
//  DateHelper.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 28/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DateHelper.h"

static NSDateFormatter *sDateFormatter = nil;

@implementation DateHelper

+ (NSString *)stringWithDate:(NSDate *)date {
    if (sDateFormatter == nil) {
        sDateFormatter = [[NSDateFormatter alloc] init];
    }
    [sDateFormatter setDateFormat:@"YYYY-MM-dd"];
    return [sDateFormatter stringFromDate:date];
}

+ (NSDate *)dateWithString:(NSString *)date {
    if (sDateFormatter == nil) {
        sDateFormatter = [[NSDateFormatter alloc] init];
    }
    [sDateFormatter setDateFormat:@"YYYY-MM-dd"];
    return [sDateFormatter dateFromString:date];
}

+ (NSString *)currentDate {
    if (sDateFormatter == nil) {
        sDateFormatter = [[NSDateFormatter alloc] init];
    }
    [sDateFormatter setDateFormat:@"YYYY-MM-dd"];
    return [sDateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)currentDateAndTime {
    if (sDateFormatter == nil) {
        sDateFormatter = [[NSDateFormatter alloc] init];
    }
    [sDateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    return [sDateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)dateFormatForGraph:(NSString *)dateString{
    if (sDateFormatter == nil) {
        sDateFormatter = [[NSDateFormatter alloc] init];
    }
    [sDateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [sDateFormatter dateFromString:dateString];
    [sDateFormatter setDateFormat:@"dd/MM"];
    dateString = [sDateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)dateFormatForGraphData: (NSString *)dateString{
    if (sDateFormatter == nil) {
        sDateFormatter = [[NSDateFormatter alloc] init];
    }
    [sDateFormatter setDateFormat:@"yyyy"];
    NSDate *dateYear = [NSDate date];
    NSInteger currentYear = [[sDateFormatter stringFromDate:dateYear] integerValue];
    [sDateFormatter setDateFormat:@"dd/MM"];
    NSDate *date = [sDateFormatter dateFromString:dateString];
    [sDateFormatter setDateFormat:@"MM-dd"];
    dateString = [sDateFormatter stringFromDate:date];
    dateString = [NSString stringWithFormat:@"%ld-%@",(long)currentYear,dateString];
    return dateString;
}

@end
