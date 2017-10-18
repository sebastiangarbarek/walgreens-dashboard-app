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

- (void)loadCellDataWithOfflineStores:(NSArray *)offlineStores {
    
    
    [self configureChart];
    [self updateLineChartWithXValues:daysOfTheMonth yValues:onlineStoreNumbersForMonth];
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

@end
