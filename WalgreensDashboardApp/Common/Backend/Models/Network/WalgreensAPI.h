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
#import "WalgreensAPIDelegate.h"
#import "WalgreensAPIConstants.h"

@interface WalgreensAPI : NSObject

@property (nonatomic, weak) id <WalgreensAPIDelegate> delegate;

@property (atomic) NSThread *thread;

- (void)requestStoresInList:(NSArray *)storeList;
- (void)requestStore:(NSString *)storeNumber;

@end
