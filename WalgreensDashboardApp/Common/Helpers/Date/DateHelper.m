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

+ (BOOL)currentDateTimeIsAtLeastMinutes:(long)minutes aheadOf:(NSDate *)dateTime timesChecked:(int)timesChecked {
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitMinute;
    NSDateComponents *results = [calender components:unitFlags fromDate:dateTime toDate:[NSDate date] options:0];
    
    // Must factor number of times checked and the interval.
    if ([results minute] > (minutes + (timesChecked * minutes))) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)dateFormatForGraph:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"dd/MM"];
    dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)dateFormatForGraphData: (NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSDate *dateYear = [NSDate date];
    NSInteger currentYear = [[dateFormatter stringFromDate:dateYear] integerValue];
    [dateFormatter setDateFormat:@"dd/MM"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"MM-dd"];
    dateString = [dateFormatter stringFromDate:date];
    dateString = [NSString stringWithFormat:@"%ld-%@",(long)currentYear,dateString];
    return dateString;
}

@end
