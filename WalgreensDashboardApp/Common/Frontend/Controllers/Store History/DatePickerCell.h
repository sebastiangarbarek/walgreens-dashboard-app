//
//  DatePickerCell.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "OfflineHistoryCell.h"
#import "DatePickerDelegate.h"
#import "Month.h"

@interface DatePickerCell : OfflineHistoryCell <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) id <DatePickerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIPickerView *datePicker;

@end
