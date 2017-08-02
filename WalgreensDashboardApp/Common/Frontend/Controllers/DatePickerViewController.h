//
//  DatePickerViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 2/08/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DateHelper.h"
#import "DatabaseManagerApp.h"

@interface DatePickerViewController : UIViewController <UITabBarControllerDelegate>

@property DatabaseManagerApp *databaseManagerApp;

@property (weak, nonatomic) UIBarButtonItem *nextButton;
@property (weak, nonatomic) UIBarButtonItem *previousButton;

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *nextDate;
@property (strong, nonatomic) NSString *previousDate;

- (void)checkDates;
- (void)setDateForView:(NSString *)date;
- (void)enableButtonWithNextDate:(NSString *)nextDate;
- (void)enableButtonWithPreviousDate:(NSString *)previousDate;
- (void)disableNextDateButton;
- (void)disablePreviousDateButton;

@end
