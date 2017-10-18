//
//  OnlineTrendCell.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "OnlineTrendCell.h"

@implementation OnlineTrendCell

#pragma mark - Parent Methods -

- (void)loadCellDataWithOfflineStores:(NSArray *)offlineStoresForMonthInYear month:(NSNumber *)month year:(NSNumber *)year databaseManager:(DatabaseManagerApp *)databaseManager {
    NSArray *chartData = [self buildChartDataWithMonth:month year:year databaseManager:databaseManager];
    NSArray *dayLabels = chartData[0];
    NSArray *onlineStoreNumbersForMonth = chartData[1];
    
    [self configureChart];
    [self updateLineChartWithXValues:dayLabels yValues:onlineStoreNumbersForMonth];
}

#pragma mark - Chart Methods -

- (void)updateLineChartWithXValues:(NSArray<NSString *> *)xValues yValues:(NSArray *)yValues {
    NSMutableArray<ChartDataEntry *> *chartDataEntries = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [yValues count]; i++) {
        ChartDataEntry *chartDataEntry = [[ChartDataEntry alloc] initWithX:i y:[yValues[i] doubleValue]];
        [chartDataEntries addObject:chartDataEntry];
    }
    
    LineChartDataSet *lineChartDataSet = [self formatDataSetWithDataEntries:chartDataEntries];
    LineChartData *lineChartData = [[LineChartData alloc] initWithDataSet:lineChartDataSet];
    
    self.lineChart.data = lineChartData;
    self.lineChart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xValues];
}

- (void)configureChart {
    self.lineChart.xAxis.labelPosition = XAxisLabelPositionBottom;
    self.lineChart.descriptionText = @"";
}

- (LineChartDataSet *)formatDataSetWithDataEntries:(NSArray<ChartDataEntry *> *)chartDataEntries {
    LineChartDataSet *lineChartDataSet = [[LineChartDataSet alloc] initWithValues:chartDataEntries label:@"Stores Online"];
    
    [lineChartDataSet setCircleColor:[UIColor printicularYellow]];
    [lineChartDataSet setCircleHoleColor:[UIColor printicularYellow]];
    [lineChartDataSet setColor:[UIColor printicularYellow]];
    
    return lineChartDataSet;
}

#pragma mark - Helper Methods -

- (NSArray *)buildChartDataWithMonth:(NSNumber *)month year:(NSNumber *)year databaseManager:(DatabaseManagerApp *)databaseManager {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setYear:[year integerValue]];
    [components setMonth:[month integerValue]];
    
    NSDate *date = [calendar dateFromComponents:components];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    NSInteger totalPrintStores = [[databaseManager.selectCommands countPrintStoresInStoreTable] integerValue];
    
    NSMutableArray *dayLabels = [NSMutableArray new];
    NSMutableArray *onlineNumbers = [NSMutableArray new];
    for (int i = 1; i <= range.length; i++) {
        NSInteger offlineStores = [databaseManager.selectCommands countOfflineStoresForDay:@(i) inMonth:month year:year];
        
        if (offlineStores != 0) {
            [onlineNumbers addObject:@(totalPrintStores - offlineStores)];
        } else {
            [onlineNumbers addObject:@(totalPrintStores)];
        }
        
        [dayLabels addObject:[NSString stringWithFormat:@"%i/%@", i, month]];
    }
    
    return @[dayLabels, onlineNumbers];
}

@end
