//
//  NetworkUtility.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 26/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WalgreensAPI.h"

@interface NetworkUtility : NSObject

+ (void)requestStoreList:(void(^)(NSArray *storeList, NSError *sessionError))complete;
+ (void)requestProductList:(void(^)(NSDictionary *productList))complete;
+ (NSMutableURLRequest *)buildRequestFrom:(NSString *)url andRequestData:(NSMutableDictionary *)requestData;
+ (BOOL)did404:(NSURLResponse *)urlResponse;
+ (BOOL)validResponse:(NSURLResponse *)urlResponse withError:(NSError *)sessionError andData:(NSData *)responseData;
+ (double)percentCompleteWithCount:(NSInteger)count andTotal:(NSInteger)total;

@end
