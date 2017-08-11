//
//  HistoryTableViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "HomeViewController.h"
#import "DatabaseManagerApp.h"

@interface HistoryTableViewController () {
    DatabaseManagerApp *databaseManagerApp;
}
@property (strong, nonatomic) IBOutlet LineChartView *graphForOnlineStores;
@property (strong, nonatomic) IBOutlet LineChartView *graphForOfflineStores;

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Retrieve selected date from home view controller.
    self.date = ((HomeViewController *)self.parentViewController).date;
    _xaixsWithDate = [[NSMutableArray alloc] init];
    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    // Database closes itself after use.
    [databaseManagerApp openCreateDatabase];
    
    
    
    _xaixsWithDate = [self setXAixsArray:_xaixsWithDate];
    
    NSMutableArray *onlineStoreNumberData = [self getStoreNumberFor:_xaixsWithDate :@"Online"];
    NSMutableArray *offlineStoreNumberData = [self getStoreNumberFor:_xaixsWithDate :@"Offline"];
    
    _graphForOnlineStores.data = [self setDataForStores:_xaixsWithDate:onlineStoreNumberData: @"Online" :_graphForOnlineStores];
    _graphForOfflineStores.data = [self setDataForStores:_xaixsWithDate :offlineStoreNumberData: @"Offline" :_graphForOfflineStores];
    
    [self reloadData];
}

- (void)reloadData {
    self.date = ((HomeViewController *)self.parentViewController).date;
    
    self.totalOnlineStoresLabel.text = [NSString stringWithFormat:@"%i",
                                        ([[databaseManagerApp.selectCommands countPrintStoresInStoreTable] intValue]
                                         - [[databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:self.date] intValue])];
    self.totalOfflineStoresLabel.text = [NSString stringWithFormat:@"%i",
                                         [[databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:self.date] intValue]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        // Store status section.
        case 0: {
            switch (indexPath.row) {
                // Online row.
                case 0: {
                    break;
                }
                // Offline row.
                case 2: {
                    // Get home view.
                    HomeViewController *homeViewController = (HomeViewController *)self.parentViewController;
                    
                    // Swap container view.
                    UIStoryboard *offlineStoryBoard = [UIStoryboard storyboardWithName:@"OfflineView" bundle:nil];
                    UITableViewController *offlineTableViewController = [offlineStoryBoard instantiateViewControllerWithIdentifier:@"Offline Table View"];
                    [homeViewController animateTransitionTo:offlineTableViewController transition:Push];
                    
                    [homeViewController switchBackButton];
                    
                    break;
                }
            }
            break;
        }
    }
    // Push selected view onto navigation stack.
}

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
            //NSLog(@"------%@------",dataArray);
        }
    }
    return dataArray;
    
}


- (LineChartData *) setDataForStores: (NSMutableArray *) xAxis : (NSMutableArray *) dataArray : (NSString *) storeStatus :(LineChartView *)inchart{
    //set x axis
    inchart.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xAxis];
    inchart.xAxis.granularity =1.0;
    [self setChartStyle:inchart];
    
    NSMutableArray *yAxisData = [[NSMutableArray alloc] init];
    NSMutableArray *yAxis = [[NSMutableArray alloc] init];
    
    //Set y axis based on store status
    if([storeStatus isEqualToString:@"Online"]){
        yAxisData = [NSMutableArray arrayWithObjects:@"7300",@"7320",@"7340",@"7350",@"7360",nil];
    }else{
        yAxisData = [NSMutableArray arrayWithObjects:@"0",@"2",@"4",@"6",@"8",nil];
    }
    
    
    //set y axis
    inchart.leftAxis.granularityEnabled = YES;
    inchart.leftAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:yAxisData];
    inchart.leftAxis.granularity = 1.0;
    inchart.leftAxis.labelCount = 5;
    inchart.leftAxis.forceLabelsEnabled = YES;
    
    double index = [yAxisData count];
    
    for (int i = 0; i < index; i++) {
        double storeNumber = [yAxisData[i] doubleValue];
        NSLog(@"-%f-",storeNumber);
        
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
        //Set Value color and line color
        //dataSet.valueColors =
        //[dataSet setColor:]
        
        //Set value points radio
        //dataSet.circleColors =
        //dataSet.circleRadius =
        //dataSet.circleHoleColor =
        //dataSet.circleHoleRadius =
        
        LineChartDataSet *dataSet2 = [dataSet copy];
        NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
        
        double index2 = [dataArray count];
        
        for (int i = 0; i < index2; i++) {
            double storeNumber = [dataArray[i] doubleValue];
            
            ChartDataEntry *dataEntry = [[[ChartDataEntry alloc] init] initWithX:i y:storeNumber];
            
            [yVals2 addObject:dataEntry];
        }
        
        dataSet2.values = yVals2;
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
       // [dataSets addObject:dataSet];
        [dataSets addObject:dataSet2];
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        return data;
    }
    
}

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
    [chart animateWithXAxisDuration:1.0];
    
    //remove the right y axis number
    chart.rightAxis.enabled = NO;

}
//todo


@end
