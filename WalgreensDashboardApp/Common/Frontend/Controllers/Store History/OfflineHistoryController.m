//
//  OfflineHistoryController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "OfflineHistoryController.h"

@interface OfflineHistoryController () {
    NSNumber *selectedMonth;
    NSNumber *selectedYear;
    NSArray *offlineStoresForMonthInYear;
    
    NSArray *sectionTitles;
    NSDictionary *numberOfRowsToSection;
    
    BOOL didLoadInitialGraph;
}

@end

@implementation OfflineHistoryController

#pragma mark - Parent Methods -

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Modify when adding or removing sections or rows.
    sectionTitles = @[@"Create Report For", @"Online Trend", @"Summary"];
    numberOfRowsToSection = @{sectionTitles[0] : @(1),
                              sectionTitles[1] : @(1),
                              sectionTitles[2] : @(1)};
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self configureViewOnAppearWithThemeColor:[UIColor printicularRed]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    for (int i = 0; i < 3; i++)
        NSLog(@"Offline history screen received memory warning.");
}

#pragma mark - Table Methods -

// Table is treated statically. There is no dynamic adding or removing of rows.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[numberOfRowsToSection objectForKey:[sectionTitles objectAtIndex:section]] integerValue];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            DatePickerCell *datePicker = [tableView dequeueReusableCellWithIdentifier:@"Date Picker"];
            datePicker.delegate = self;
            [datePicker loadDatePickerData:self.databaseManager];
            return datePicker;
            break;
        }
        case 1:
            return [self smartDequeueWithIdentifier:@"Online Trend"];
        case 2:
            return [self smartDequeueWithIdentifier:@"Summary"];
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            // Date picker.
            return 88;
            break;
        case 1:
            // Online trend.
            return 216;
            break;
        case 2: {
            // Summary.
            CGRect screen = [[UIScreen mainScreen] bounds];
            return screen.size.width;
            break;
        }
        default:
            break;
    }
    return 0;
}

#pragma mark - Picker Delegate Methods -

- (void)datePickerDidLoadWithInitialMonth:(NSNumber *)initialMonth initialYear:(NSNumber *)initialYear {
    if (!didLoadInitialGraph) {
        // Cells load in order.
        selectedMonth = initialMonth;
        selectedYear = initialYear;
        offlineStoresForMonthInYear = [self.databaseManager.selectCommands selectOfflineStoresForMonth:initialMonth year:initialYear];
        didLoadInitialGraph = YES;
    }
}

- (void)datePickerDidSelectMonth:(NSNumber *)month withYear:(NSNumber *)year {
    selectedMonth = month;
    selectedYear = year;
    offlineStoresForMonthInYear = [self.databaseManager.selectCommands selectOfflineStoresForMonth:month year:year];
    [self.tableView reloadData];
}

#pragma mark - Helper Methods -

- (OfflineHistoryCell *)smartDequeueWithIdentifier:(NSString *)identifier {
    OfflineHistoryCell *offlineHistoryCell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    [offlineHistoryCell loadCellDataWithOfflineStores:offlineStoresForMonthInYear month:selectedMonth year:selectedYear databaseManager:self.databaseManager];
    return offlineHistoryCell;
}

@end
