//
//  NetworkUtility.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 26/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "NetworkUtility.h"

@implementation NetworkUtility

+ (void)requestStoreList:(void(^)(NSArray *storeList, BOOL notConnected, BOOL serviceDown))complete {
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    [requestDictionary setValue:kApiKey forKey:@"apiKey"];
    [requestDictionary setValue:kAffId forKey:@"affId"];
    [requestDictionary setValue:@"storeNumber" forKey:@"act"];
    
    printf("[STORE LIST] Requesting store list...\n");
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:[NetworkUtility buildRequestFrom:kStoreListServiceUrl requestData:requestDictionary]
                completionHandler:^(NSData *responseData, NSURLResponse *urlResponse, NSError *sessionError) {
                    if (sessionError) {
                        printf("[STORE LIST 🍎] Session error.\n");
                        if (sessionError.code == NSURLErrorNotConnectedToInternet) {
                            printf("[STORE LIST 🍎] Not connected to the internet.\n");
                            complete(nil, YES, NO);
                            return;
                        }
                    }
                    
                    if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSInteger statusCode = [(NSHTTPURLResponse *)urlResponse statusCode];
                        
                        if (statusCode == 200) {
                            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                            
                            if (!responseDictionary) {
                                complete(nil, NO, NO);
                            } else if ([responseDictionary valueForKey:@"store"]) {
                                printf("[STORE LIST 🍏] Store list retrieved successfully.\n");
                                
                                NSArray *list = [responseDictionary valueForKey:@"store"];
                                
                                NSMutableArray *storeList = [NSMutableArray new];
                                
                                for (int i = 0; i < [list count]; i++) {
                                    // To NSString object.
                                    [storeList addObject:[list[i] stringValue]];
                                }
                                
                                complete(storeList, NO, NO);
                            }
                        }
                        else if (statusCode == 404) {
                            printf("[STORE LIST 🍎] Does not exist on the server.\n");
                            complete(nil, NO, NO);
                        }
                        else if (statusCode == 503) {
                            printf("[STORE LIST 🍎] Service is temporarily unavailable.\n");
                            complete(nil, NO, NO);
                        }
                        else if (statusCode == 504) {
                            printf("[STORE LIST 🍎] Request took too long to send.\n");
                            complete(nil, NO, NO);
                        }
                        else if (statusCode >= 506 && statusCode <= 512) {
                            printf("[STORE LIST 🍎] Service is down.\n");
                            complete(nil, NO, YES);
                        }
                        else {
                            printf("[STORE LIST 🍎] Something went wrong.\n");
                            complete(nil, NO, NO);
                        }
                    } else {
                        printf("[STORE LIST 🍎] Invalid response.\n");
                        complete(nil, NO, YES);
                    }
                }] resume];
}

+ (void)requestProductList:(void(^)(NSDictionary *productList, BOOL notConnected))complete {
    
}

+ (NSMutableURLRequest *)buildRequestFrom:(NSString *)url requestData:(NSMutableDictionary *)requestData {
    NSData *jsonRequestData = [NSJSONSerialization dataWithJSONObject:requestData options:NSJSONWritingPrettyPrinted error:nil];
    NSURL *requestURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:requestURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonRequestData];
    return request;
}

@end
