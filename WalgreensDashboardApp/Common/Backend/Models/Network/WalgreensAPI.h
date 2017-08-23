//
//  WalgreensAPI.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 24/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetworkUtility.h"
#import "Reachability.h"

static NSString *const apiKey = @"HaVvNTNGKqsZuZR8ARAC0q3rvAeuam5P";
static NSString *const affId = @"photoapi";
static NSString *const storeListServiceUrl = @"https://services-qa.walgreens.com/api/util/storenumber";
static NSString *const storeDetailServiceUrl = @"https://services-qa.walgreens.com/api/stores/details";

@class WalgreensAPI;

@protocol WalgreensAPIDelegate <NSObject>

@required
- (void)walgreensApiDidPassStore:(WalgreensAPI *)sender withData:(NSDictionary *)responseDictionary forStore:(NSString *)storeNumber;
@required
- (void)walgreensApiDidFailStore:(WalgreensAPI *)sender forStore:(NSString *)storeNumber;
@required
- (void)walgreensApiDidSendAll:(WalgreensAPI *)sender;

@end

@interface WalgreensAPI : NSObject

@property (nonatomic, weak) id <WalgreensAPIDelegate> delegate;
@property (atomic, weak) NSThread *currentExecutingThread;

- (instancetype)initWithSemaphore:(dispatch_semaphore_t)semaphore;
- (void)requestAllStoresInList:(NSArray *)storeList;
- (void)requestStore:(NSString *)storeId;

@end
