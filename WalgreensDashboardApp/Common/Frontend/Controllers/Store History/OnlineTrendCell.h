//
//  OnlineTrendCell.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 18/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "OfflineHistoryCell.h"

#import "UIColor+AppTheme.h"
#import "Charts-Swift.h"
#import "DatabaseConstants.h"

@interface OnlineTrendCell : OfflineHistoryCell

@property (weak, nonatomic) IBOutlet LineChartView *lineChart;

@end
