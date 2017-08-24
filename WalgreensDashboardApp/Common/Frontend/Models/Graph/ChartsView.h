//
//  ChartsViewController.h
//  WalgreensDashboardApp
//
//  Created by NAN JIANG on 2017/8/12.
//  Copyright © 2017年 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateHelper.h"
#import "WalgreensDashboardApp-Bridging-Header.h"

@interface ChartsView : NSObject

@property (strong, nonatomic) NSString *currentDay;
@property (strong, nonatomic) NSMutableArray *xaixsWithDate;
@property (strong, nonatomic) NSString *nextDateForArray;
@property (strong, nonatomic) NSString *previousDateForArray;
@property (strong, nonatomic) NSString *selectedDate;
@property (strong, nonatomic) NSString *date;

- (void)previousDaysArray:(NSMutableArray *)storedArrayWith :(NSString *)selectedDay;
- (void)nextDaysArray:(NSMutableArray *) storedArrayWith :(NSString *)selectedDay;
- (NSMutableArray *)setXAixsArray:(NSMutableArray *)dataArray;
- (NSString *)getSelectedDate;
- (NSMutableArray *) getStoreNumberFor: (NSMutableArray *) dateArray : (NSString *) storeStatus;
- (LineChartData *) setDataForStores: (NSMutableArray *) xAxis : (NSMutableArray *) dataArray : (NSString *) storeStatus :(LineChartView *)inchart;
- (void) setChartStyle:(LineChartView *)chart;
- (void)setSelfDate : (NSString *) date;

@end
