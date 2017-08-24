//
//  NSMutableArray+Stack.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 9/08/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)

- (void)push:(id)o {
    [self addObject:o];
}

- (id)pop {
    id o;
    if ([self count] > 0) {
        o = [self lastObject];
        [self removeLastObject];
    }
    return o;
}

- (id)peek {
    if ([self count] != 0)
        return [self lastObject];
    else
        return nil;
}

@end
