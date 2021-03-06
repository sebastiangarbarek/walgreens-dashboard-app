//
//  Month.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Month : NSObject

@property NSString *monthName;
@property NSNumber *monthNumber;

- (instancetype)initWithMonthNumber:(NSNumber *)monthNumber;

@end
