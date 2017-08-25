//
//  DateHelper.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 28/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+ (NSString *)stringWithDate:(NSDate *)date;
+ (NSDate *)dateWithString:(NSString *)date;
+ (NSString *)currentDate;
+ (NSString *)currentDateAndTime;
+ (NSString *)dateFormatForGraph: (NSString *)dateString;
+ (NSString *)dateFormatForGraphData: (NSString *)dateString;

@end
