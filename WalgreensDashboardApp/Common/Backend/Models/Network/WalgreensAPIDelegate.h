//
//  WalgreensAPIDelegate.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 16/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WalgreensAPIDelegate <NSObject>

@required
- (void)walgreensApiOnlineStoreWithData:(NSDictionary *)responseDictionary storeNumber:(NSString *)storeNumber;
- (void)walgreensApiOfflineStoreWithData:(NSDictionary *)responseDictionary storeNumber:(NSString *)storeNumber;
- (void)walgreensApiScheduledMaintenanceStoreWithData:(NSDictionary *)responseDictionary storeNumber:(NSString *)storeNumber;
- (void)walgreensApiUnscheduledMaintenanceStoreWithData:(NSDictionary *)responseDictionary storeNumber:(NSString *)storeNumber;
- (void)walgreensApiStoreDoesNotExistWithStoreNumber:(NSString *)storeNumber;
- (void)walgreensApiIsDown;

@end
