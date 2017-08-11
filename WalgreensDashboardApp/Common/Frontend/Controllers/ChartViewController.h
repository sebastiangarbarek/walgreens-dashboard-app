//
//  ChartViewController.h
//  WalgreensDashboardApp
//
//  Created by NAN JIANG on 2017/8/11.
//  Copyright © 2017年 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
#import "WalgreensDashboardApp-Bridging-Header.h"

@interface ChartViewController : DatePickerViewController 

@property (strong, nonatomic) NSString *currentDay;
@property (strong, nonatomic) NSMutableArray *xaixsWithDate;
@property (strong, nonatomic) NSMutableArray *arrayWithThreeDaysLater;
@property (strong, nonatomic) NSMutableArray *arrayWithThreeDaysBefore;
@property (strong, nonatomic) NSArray *yaixsWithNumberOfStore;

@end
