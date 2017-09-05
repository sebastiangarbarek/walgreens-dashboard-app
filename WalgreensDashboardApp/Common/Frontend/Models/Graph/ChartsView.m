//
//  ChartsViewController.m
//  WalgreensDashboardApp
//
//  Created by NAN JIANG on 2017/8/12.
//  Copyright © 2017年 Sebastian Garbarek. All rights reserved.
//

#import "ChartsView.h"
#import "DatabaseManagerApp.h"
#import "YAxisFomatter.h"
#import "HomeViewController.h"
#import "SetValueFormatter.h"


@interface ChartsView (){
    DatabaseManagerApp *databaseManagerApp;
}

@end

@implementation ChartsView

-(id)init{
    if (self = [super init]) {
        databaseManagerApp = [[DatabaseManagerApp alloc] init];
        
        //self.date = (HomeViewController*)self.date;
        // Database closes itself after use.
        [databaseManagerApp openCreateDatabase];
    }
    return self;
}

#pragma -Get the data for chart-

- (void)previousDaysArray:(NSMutableArray *)storedArrayWith :(NSString *)selectedDay{
    int i = 3;
    NSString *previousDateForArray = [databaseManagerApp.selectCommands selectPreviousUpdateDateInHistoryTableWithDate:selectedDay];
    while (previousDateForArray) {
        if(i>=1){
            self.previousDateForArray = previousDateForArray;
            previousDateForArray = [databaseManagerApp.selectCommands selectPreviousUpdateDateInHistoryTableWithDate:self.previousDateForArray];
            [storedArrayWith addObject:[DateHelper dateFormatForGraph:self.previousDateForArray]];
            i--;
        }else{
            break;
        }
    }
}

- (void)nextDaysArray:(NSMutableArray *) storedArrayWith :(NSString *)selectedDay{
    int i = 3;
    NSString *nextDateForArray = [databaseManagerApp.selectCommands selectNextUpdateDateInHistoryTableWithDate:selectedDay];
    while (nextDateForArray) {
        if(i>=1){
            self.nextDateForArray = nextDateForArray;
            nextDateForArray = [databaseManagerApp.selectCommands selectNextUpdateDateInHistoryTableWithDate:self.nextDateForArray];
            [storedArrayWith addObject:[DateHelper dateFormatForGraph:self.nextDateForArray]];
            i--;
        }else{
            break;
        }
    }
}

- (NSString *)getSelectedDate {
    _selectedDate = self.date;
    return _selectedDate;
}

- (void)setSelfDate : (NSString *) date {
    self.date = date;
}

- (NSMutableArray *)setXAixsArray:(NSMutableArray *)dataArray{
    _currentDay = [self getSelectedDate];
    //add previous 3 days to array
    [self previousDaysArray:dataArray:_currentDay];
    
    //Reverse the mutable array
    dataArray = [[[dataArray reverseObjectEnumerator] allObjects] mutableCopy];
    
    //add today to array
    [dataArray addObject:[DateHelper dateFormatForGraph:_currentDay]];
    
    //add next 3 days to array
    [self nextDaysArray:dataArray :_currentDay];
    return dataArray;
    
}


- (NSMutableArray *) getStoreNumberFor: (NSMutableArray *) dateArray : (NSString *) storeStatus{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    for (NSString *string in dateArray) {
        if([storeStatus isEqualToString:@"Online"]){
            [dataArray addObject:[NSString stringWithFormat:@"%i",([[databaseManagerApp.selectCommands countPrintStoresInStoreTable] intValue]
                                                                   - [[databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:[DateHelper dateFormatForGraphData:string]] intValue])]];
        }
        else{
            [dataArray addObject:[NSString stringWithFormat:@"%i",
                                  [[databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:[DateHelper dateFormatForGraphData:string]] intValue]]];
        }
    }
    return dataArray;
    
}

#pragma -Set Chart Methods-

- (LineChartData *) setDataForStores: (NSMutableArray *) xAxis : (NSMutableArray *) dataArray : (NSString *) storeStatus :(LineChartView *)inchart{
    //set x axis
    inchart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xAxis];
    inchart.xAxis.granularity =1.0;
    
    //set chart style
    [self setChartStyle:inchart];
    
    NSMutableArray *yAxis = [[NSMutableArray alloc] init];
    
    double index = [dataArray count];
    
    for (int i = 0; i < index; i++) {
        double storeNumber = [dataArray[i] doubleValue];
        
        ChartDataEntry *dataEntry = [[[ChartDataEntry alloc] init] initWithX:i y:storeNumber];
        
        [yAxis addObject:dataEntry];
    }
    
    LineChartDataSet *dataSet = nil;
    if (inchart.data.dataSetCount > 0){
        LineChartData *data = (LineChartData *)inchart.data;
        dataSet = (LineChartDataSet *)data.dataSets[0];
        dataSet.values = yAxis;
        return data;
    }else{
        dataSet = [[LineChartDataSet alloc] initWithValues:yAxis label:nil];
        dataSet.valueFormatter = [[SetValueFormatter alloc]initWithArr:yAxis];
        //Set Value color and line color
        //dataSet.valueColors =
        //[dataSet setColor:]
        
        //dataSet.circleHoleColor =
        dataSet.circleRadius = 8.0;
        dataSet.circleHoleRadius = 4.0;
        
        //Set y axis
        inchart.leftAxis.valueFormatter = [[YAxisFomatter alloc] init];
        inchart.leftAxis.granularity = 1.0;
        
        dataSet.highlightEnabled = NO;
        dataSet.lineWidth = 1.0;
        
        
        //Set y axis data array, line color and points color based on store status
        NSMutableArray *yAxisData = [[NSMutableArray alloc] init];
        if([storeStatus isEqualToString:@"Online"]){
            //Set online data array
            yAxisData = [NSMutableArray arrayWithObjects:@"7100",@"7200",@"7300",@"7400",@"7500",nil];
            //Set online point color
            [dataSet setCircleColor:[UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:0.5]];
            //Set the hole color
            dataSet.circleHoleColor = [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:1.0];
            //Set the line color
            [dataSet setColor:[UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:1.0]];
        }else{
            //Offline data array
            yAxisData = [NSMutableArray arrayWithObjects:@"0",@"2",@"4",@"6",@"8",nil];
            //Set offline point color
            [dataSet setCircleColor:[UIColor colorWithRed:255/255.0 green:99/255.0 blue:71/255.0 alpha:0.5]];
            //Set the hole color
            dataSet.circleHoleColor = [UIColor colorWithRed:255/255.0 green:99/255.0 blue:71/255.0 alpha:1.0];
            //Set the line color
            [dataSet setColor:[UIColor colorWithRed:255/255.0 green:99/255.0 blue:71/255.0 alpha:0.9]];
        }
        
        NSMutableArray *yVal2 = [[NSMutableArray alloc] init];
        double indexForYaxis = [yAxisData count];
        for (int i = 0; i < indexForYaxis; i++){
            double yAix = [yAxisData[i] doubleValue];
            ChartDataEntry *yaxisEntry = [[[ChartDataEntry alloc] init] initWithX:i y:yAix];
            [yVal2 addObject:yaxisEntry];
        }
        LineChartDataSet *setForY = [dataSet copy];
        setForY.values = yVal2;
        
        //set y not visible
        setForY.visible = NO;
        
        //init data sets
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        
        //Add data set
        [dataSets addObject:dataSet];
        [dataSets addObject:setForY];
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        //Set the font size and color
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:8.f]];
        [data setValueTextColor:[UIColor blackColor]];
        
        return data;
    }
    
}

//Set chart style
- (void) setChartStyle:(LineChartView *)chart{
    //set the xaxis to bottom
    chart.xAxis.labelPosition = XAxisLabelPositionBottom;
    
    //set the charts can't move
    chart.dragEnabled = NO;
    chart.scaleXEnabled = NO;
    chart.scaleYEnabled = NO;
    
    //hide the text
    chart.legend.enabled = NO;
    chart.descriptionText = @"";
    
    //add animation
    //[chart animateWithXAxisDuration:1.0];
    
    //remove the x lines
    chart.xAxis.drawGridLinesEnabled = NO;
    
    
}

@end
