//
//  YAxisFomatter.m
//  WalgreensDashboardApp
//
//  Created by NAN JIANG on 2017/8/12.
//  Copyright © 2017年 Sebastian Garbarek. All rights reserved.
//

#import "YAxisFomatter.h"

@interface YAxisFomatter(){
    NSArray *_arr;
}

@end

@implementation YAxisFomatter
-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithArr:(NSArray *)arr{
    self = [super init];
    if (self)
    {
        _arr = arr;
        
    }
    return self;
}

//Return y axis value
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    
    return [NSString stringWithFormat:@"%ld",(NSInteger)value];
}

@end
