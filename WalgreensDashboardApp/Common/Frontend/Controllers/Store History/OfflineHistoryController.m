//
//  OfflineHistoryController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "OfflineHistoryController.h"

@interface OfflineHistoryController () {
    NSArray *offlineStoresForMonthAndYear;
    
    NSArray *sectionTitles;
    NSDictionary *numberOfRowsToSection;
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
    sectionTitles = @[@"Report For", @"Online Trend"];
    numberOfRowsToSection = @{sectionTitles[0] : @(1),
                              sectionTitles[1] : @(1)};
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
            [datePicker loadDatePickerData:self.databaseManagerApp];
            return datePicker;
            break;
        }
        case 1:
            return [self smartDequeueWithIdentifier:@"Online Trend"];
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
        default:
            break;
    }
    return 0;
}

#pragma mark - Collection Methods -



#pragma mark - Picker Delegate Methods -

- (void)datePickerDidLoadWithInitialMonth:(NSString *)initialMonth initialYear:(NSString *)initialYear {
    // Cells load in order.
    offlineStoresForMonthAndYear = [self.databaseManagerApp.selectCommands selectOfflineStoresForMonth:initialMonth year:initialYear];
}

- (void)datePickerDidSelectMonth:(NSString *)month withYear:(NSString *)year {
    offlineStoresForMonthAndYear = [self.databaseManagerApp.selectCommands selectOfflineStoresForMonth:month year:year];
    [self.tableView reloadData];
}

#pragma mark - Navigation Methods -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
}

#pragma mark - Helper Methods -

- (OfflineHistoryCell *)smartDequeueWithIdentifier:(NSString *)identifier {
    OfflineHistoryCell *offlineHistoryCell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    [offlineHistoryCell loadCellDataWithOfflineStores:<#(NSArray *)#>;
    return offlineHistoryCell;
}

@end
