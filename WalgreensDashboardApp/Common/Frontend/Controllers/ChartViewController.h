//
//  ChartViewController.h
//  WalgreensDashboardApp
//
//  Created by NAN JIANG on 2017/8/11.
//  Copyright © 2017年 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartViewController : UIViewController

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSMutableArray *xaixsWithDate;
@property (strong, nonatomic) NSMutableArray *yaixsWithNumberOfStore;

@end
