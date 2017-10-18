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
    NSNumber *selectedYear;
}

@end

@implementation DatePickerCell

#pragma mark - Parent Methods

- (void)loadDatePickerData:(DatabaseManagerApp *)databaseManager {
    monthsToYear = [NSMutableDictionary new];
    
    years = [databaseManager.selectCommands selectDistinctYearsInHistory];
    
    if ([years count]) {
        selectedYear = years[0];
        
        // Set months for each year.
        for (NSNumber *year in years) {
            NSArray *monthsForYear = [self convertMonthNumbersToMonthObjects:[databaseManager.selectCommands selectDistinctMonthsForYear:year]];
            [monthsToYear setObject:monthsForYear forKey:year];
        }
        
        // Must reload all components with new data.
        [self.datePicker reloadAllComponents];
        
        // Pass initial month and year to view controller.
        [self.delegate datePickerDidLoadWithInitialMonth:[[[monthsToYear objectForKey:selectedYear] objectAtIndex:0] monthNumber]
                                             initialYear:selectedYear];
    }
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
            return [[years objectAtIndex:row] stringValue];
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
            [self updateMonthWithRow:row];
            break;
        }
        case 1: {
            // Years.
            [self updateYearWithRow:row];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Helper Methods -

- (void)updateMonthWithRow:(NSInteger)row {
    NSNumber *selectedMonth = [[[monthsToYear objectForKey:selectedYear] objectAtIndex:row] monthNumber];
    
    [self.delegate datePickerDidSelectMonth:selectedMonth withYear:selectedYear];
}

- (void)updateYearWithRow:(NSInteger)row {
    // Use previously selected year to find current selected month.
    Month *currentMonth = [[monthsToYear objectForKey:selectedYear] objectAtIndex:[self.datePicker selectedRowInComponent:0]];
    
    // Update selected year. Must be called after the previous statement.
    selectedYear = [years objectAtIndex:row];
    
    if ([self doesContainMonth:currentMonth.monthName inYear:selectedYear]) {
        // Call update delegate with current month.
        [self.delegate datePickerDidSelectMonth:currentMonth.monthNumber withYear:selectedYear];
    } else {
        // Call update delegate with first recorded month of the year.
        [self.delegate datePickerDidSelectMonth:[[[monthsToYear objectForKey:selectedYear] objectAtIndex:0] monthNumber] withYear:selectedYear];
    }
    
    // Update months for year using selected year variable.
    [self.datePicker reloadComponent:0];
}

- (NSArray *)convertMonthNumbersToMonthObjects:(NSArray *)monthNumbers {
    NSMutableArray *months = [NSMutableArray new];
    
    for (NSNumber *monthNumber in monthNumbers) {
        Month *month = [[Month alloc] initWithMonthNumber:monthNumber];
        [months addObject:month];
    }
    
    return months;
}

- (BOOL)doesContainMonth:(NSString *)monthName inYear:(NSNumber *)year {
    NSArray *months = [monthsToYear objectForKey:year];
    
    for (Month *month in months) {
        if ([month.monthName isEqualToString:monthName]) {
            return YES;
        }
    }
    
    return NO;
}

@end
