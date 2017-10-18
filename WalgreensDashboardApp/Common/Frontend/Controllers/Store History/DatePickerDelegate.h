//
//  DatePickerDelegate.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DatePickerDelegate <NSObject>

@required
- (void)datePickerDidSelectMonth:(NSString *)month withYear:(NSString *)year;

@end

