//
//  NSMutableArray+Stack.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 9/08/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)

- (void)push:(id)o;
- (id)pop;
- (id)peek;

@end
