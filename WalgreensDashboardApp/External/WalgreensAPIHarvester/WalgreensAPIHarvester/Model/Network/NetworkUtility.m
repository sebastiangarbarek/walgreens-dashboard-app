//
//  NetworkUtility.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 26/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "NetworkUtility.h"

@implementation NetworkUtility

+ (void)requestStoreList:(void(^)(NSArray *storeList, NSError *sessionError))complete {
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    [requestDictionary setValue:apiKey forKey:@"apiKey"];
    [requestDictionary setValue:affId forKey:@"affId"];
    [requestDictionary setValue:@"storeNumber" forKey:@"act"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:[NetworkUtility buildRequestFrom:storeListServiceUrl andRequestData:requestDictionary]
                completionHandler:^(NSData *responseData, NSURLResponse *urlResponse, NSError *sessionError) {
                    if ([self did404:urlResponse]) {
                        complete(nil, nil);
                        return;
                    }
                    
                    if (sessionError) {
                        printf("[HARVESTER 🍎] Session error.\n");
                        complete(nil, sessionError);
                        return;
                    }
                    
                    if (!responseData) {
                        printf("[HARVESTER 🍎] Response data is null.\n");
                        complete(nil, nil);
                        return;
                    }
                    
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                    if (!responseDictionary) {
                        complete(nil, nil);
                    } else if ([responseDictionary valueForKey:@"store"]) {
                        // Must cast to NSString for object comparator methods.
                        NSArray *rawList = [responseDictionary valueForKey:@"store"];
                        NSMutableArray *storeList = [NSMutableArray new];
                        for (int i = 0; i < [rawList count]; i++) {
                            [storeList addObject:[rawList[i] stringValue]];
                        }
                        complete(storeList, nil);
                    } else {
                        complete(nil, nil);
                    }
                }] resume];
}

+ (void)requestProductList:(void(^)(NSDictionary *productList))complete {
    
}

+ (NSMutableURLRequest *)buildRequestFrom:(NSString *)url andRequestData:(NSMutableDictionary *)requestData {
    NSData *jsonRequestData = [NSJSONSerialization dataWithJSONObject:requestData options:NSJSONWritingPrettyPrinted error:nil];
    NSURL *requestURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:requestURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonRequestData];
    return request;
}

+ (BOOL)did404:(NSURLResponse *)urlResponse {
    if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        NSInteger statusCode = [(NSHTTPURLResponse *)urlResponse statusCode];
        if (statusCode == 404) {
            printf("[HARVESTER 🍎] HTTP response 404.\n");
            return YES;
        }
    }
    return NO;
}

+ (BOOL)validResponse:(NSURLResponse *)urlResponse withError:(NSError *)sessionError andData:(NSData *)responseData {
    if (sessionError) {
        printf("[HARVESTER 🍎] Session error.\n");
        return NO;
    }
    if (![NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil]) {
        printf("[HARVESTER 🍎] No JSON in response.\n");
        return NO;
    }
    return YES;
}

+ (double)percentCompleteWithCount:(NSInteger)count andTotal:(NSInteger)total {
    return (100 * (double)count)/(double)total;
}

@end
