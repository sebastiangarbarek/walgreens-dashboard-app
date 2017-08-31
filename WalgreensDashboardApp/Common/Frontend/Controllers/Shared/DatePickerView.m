//
//  DatePickerView.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 31/08/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView

/*!Creates a new view.
 Child classes must override this method. When each child class is created, the date should be passed into it,
 so that when the view is loaded, it loads the correct data for the date.
 * \returns A new instance of the view.
 */
+ (UIViewController *)newInstanceWithDate:(NSString *)date {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
