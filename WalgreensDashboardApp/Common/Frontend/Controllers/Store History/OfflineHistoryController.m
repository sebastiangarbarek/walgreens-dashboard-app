//
//  OfflineHistoryController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "OfflineHistoryController.h"

@interface OfflineHistoryController () {
    NSArray *sectionTitles;
}

@end

@implementation OfflineHistoryController

#pragma mark - Parent Methods -

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sectionTitles = @[@"Summary For"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table Methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        // Must set date picker delegate.
        DatePickerCell *datePicker = [tableView dequeueReusableCellWithIdentifier:@"Date Picker"];
        datePicker.delegate = self;
        [datePicker loadCellDataUsingDatabaseManager:self.databaseManagerApp];
        
        return datePicker;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            // Date picker.
            return 88;
            break;
        default:
            break;
    }
    
    return 0;
}

#pragma mark - Collection Methods -



#pragma mark - Picker Delegate Methods -

- (void)datePickerDidSelectMonth:(NSString *)month withYear:(NSString *)year {
    
}

#pragma mark - Navigation Methods -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
}

@end
