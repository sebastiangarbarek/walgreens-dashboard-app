//
//  DatePickerCell.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DatabaseManagerApp.h"
#import "DatePickerDelegate.h"
#import "Month.h"

@interface DatePickerCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) id <DatePickerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *datePicker;

- (void)loadDatePickerData:(DatabaseManagerApp *)databaseManager;

@end
