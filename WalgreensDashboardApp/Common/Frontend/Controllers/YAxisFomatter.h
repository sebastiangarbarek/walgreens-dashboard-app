//
//  YAxisFomatter.h
//  WalgreensDashboardApp
//
//  Created by NAN JIANG on 2017/8/12.
//  Copyright © 2017年 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Charts;
@interface YAxisFomatter : NSObject<IChartAxisValueFormatter>
-(id)initWithArr:(NSArray *)arr;

@end
