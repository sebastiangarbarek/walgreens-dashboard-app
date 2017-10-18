//
//  DatePickerCell.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DatePickerCell.h"

@interface DatePickerCell () {
    NSArray *years;
    NSMutableDictionary *monthsToYear;
    NSString *selectedYear;
}

@end

@implementation DatePickerCell

#pragma mark - Parent Methods

- (void)loadCellDataUsingDatabaseManager:(DatabaseManagerApp *)databaseManager {
    monthsToYear = [NSMutableDictionary new];
    
    years = [databaseManager.selectCommands selectDistinctYearsInHistory];
    
    if ([years count]) {
        selectedYear = years[0];
        
        // Set months for each year.
        for (NSString *year in years) {
            NSArray *monthsForYear = [self convertMonthNumbersToMonthObjects:[databaseManager.selectCommands selectDistinctMonthsForYear:year]];
            [monthsToYear setObject:monthsForYear forKey:year];
        }
    }
    
    // Must reload all components with new data.
    [self.datePicker reloadAllComponents];
}

#pragma mark - Picker View Methods -

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            // Months.
            return [[monthsToYear objectForKey:selectedYear] count];
            break;
        case 1:
            // Years.
            return [years count];
            break;
        default:
            break;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            // Months.
            return [[[monthsToYear objectForKey:selectedYear] objectAtIndex:row] monthName];
            break;
        case 1:
            // Years.
            return [years objectAtIndex:row];
            break;
        default:
            break;
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            // Months.
            break;
        }
        case 1: {
            // Years.
            break;
        }
        default:
            break;
    }
}

#pragma mark - Helper Methods -

- (void)updateMonthWithRow:(NSInteger)row {
    NSString *selectedMonth = [[monthsToYear objectForKey:selectedYear] monthNumber];
    
    [self.datePickerDelegate datePickerDidSelectMonth:selectedMonth withYear:selectedYear];
}

- (void)updateYearWithRow:(NSInteger)row {
    // Use previously selected year to find current selected month.
    Month *currentMonth = [[monthsToYear objectForKey:selectedYear] objectAtIndex:[self.datePicker selectedRowInComponent:0]];
    
    // Update selected year. Must be called after the previous statement.
    selectedYear = [years objectAtIndex:row];
    
    if ([self doesContainMonth:currentMonth.monthName inYear:selectedYear]) {
        // Call update delegate with current month.
        [self.datePickerDelegate datePickerDidSelectMonth:currentMonth.monthNumber withYear:selectedYear];
    } else {
        // Call update delegate with first recorded month of the year.
        [self.datePickerDelegate datePickerDidSelectMonth:[[[monthsToYear objectForKey:selectedYear] objectAtIndex:0] monthNumber] withYear:selectedYear];
    }
    
    // Update months for year using selected year variable.
    [self.datePicker reloadComponent:0];
}

- (NSArray *)convertMonthNumbersToMonthObjects:(NSArray *)monthNumbers {
    NSMutableArray *months;
    
    for (NSString *monthNumber in monthNumbers) {
        [months addObject:[[Month alloc] initWithMonthNumberString:monthNumber]];
    }
    
    return months;
}

- (BOOL)doesContainMonth:(NSString *)monthName inYear:(NSString *)year {
    NSArray *months = [monthsToYear objectForKey:year];
    
    for (Month *month in months) {
        if ([month.monthName isEqualToString:monthName]) {
            return YES;
        }
    }
    
    return NO;
}

@end
