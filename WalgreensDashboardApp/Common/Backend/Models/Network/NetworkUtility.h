//
//  NetworkUtility.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 26/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WalgreensAPIConstants.h"

@interface NetworkUtility : NSObject

+ (void)requestStoreList:(void(^)(NSArray *storeList))complete;
+ (void)requestProductList:(void(^)(NSDictionary *productList))complete;
+ (NSMutableURLRequest *)buildRequestFrom:(NSString *)url requestData:(NSMutableDictionary *)requestData;

@end
