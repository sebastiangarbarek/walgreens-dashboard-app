//
//  DatePickerViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 3/08/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DatePickerViewController.h"

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.databaseManagerApp = [[DatabaseManagerApp alloc] init];
    // Database closes itself after use.
    [self.databaseManagerApp openCreateDatabase];
}

- (void)checkDates {
    NSString *nextDate = [self.databaseManagerApp.selectCommands selectNextUpdateDateInHistoryTableWithDate:self.date];
    
    if (![self.date isEqualToString:[DateHelper currentDate]]) {
        if (!nextDate) {
            // Check if next date is current date.
            NSDate *laterDate = [[DateHelper dateWithString:[DateHelper currentDate]] laterDate:[DateHelper dateWithString:self.date]];
            ([laterDate isEqualToDate:[DateHelper dateWithString:[DateHelper currentDate]]]) ? [self enableButtonWithNextDate:[DateHelper currentDate]] : [self disableNextDateButton];
        } else {
            [self enableButtonWithNextDate:nextDate];
        }
    } else {
        // Equal to current day.
        [self disableNextDateButton];
    }
    
    NSString *previousDate = [self.databaseManagerApp.selectCommands selectPreviousUpdateDateInHistoryTableWithDate:self.date];
    
    if (!previousDate) {
        // Can't go forward in time so no check for current.
        [self disablePreviousDateButton];
    } else {
        [self enableButtonWithPreviousDate:previousDate];
    }
}

- (void)setDateForView:(NSString *)date {
    self.date = date;
    if ([self.date isEqualToString:[DateHelper currentDate]]) {
        self.dateTitle.title = @"Today";
    } else
        self.dateTitle.title = self.date;
}

- (void)enableButtonWithNextDate:(NSString *)nextDate {
    self.nextButton.enabled = YES;
    self.nextDate = nextDate;
}

- (void)enableButtonWithPreviousDate:(NSString *)previousDate {
    self.previousButton.enabled = YES;
    self.previousDate = previousDate;
}

- (void)disableNextDateButton {
    self.nextButton.enabled = NO;
    self.nextDate = nil;
}

- (void)disablePreviousDateButton {
    self.previousButton.enabled = NO;
    self.previousDate = nil;
}

@end
