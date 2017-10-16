//
//  NetworkUtility.m
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 26/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "NetworkUtility.h"

@implementation NetworkUtility

+ (void)requestStoreList:(void(^)(NSArray *storeList))complete {
    NSMutableDictionary *requestDictionary = [NSMutableDictionary dictionary];
    [requestDictionary setValue:apiKey forKey:@"apiKey"];
    [requestDictionary setValue:affId forKey:@"affId"];
    [requestDictionary setValue:@"storeNumber" forKey:@"act"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:[NetworkUtility buildRequestFrom:storeListServiceUrl requestData:requestDictionary]
                completionHandler:^(NSData *responseData, NSURLResponse *urlResponse, NSError *sessionError) {
                    if ([urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
                        NSInteger statusCode = [(NSHTTPURLResponse *)urlResponse statusCode];
                        
                        if (statusCode == 200) {
                            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                            
                            if (!responseDictionary) {
                                complete(nil);
                            } else if ([responseDictionary valueForKey:@"store"]) {
                                printf("[STORE LIST 🍏] Retrieved store list successfully.\n");
                                
                                NSArray *list = [responseDictionary valueForKey:@"store"];
                                
                                NSMutableArray *storeList = [NSMutableArray new];
                                
                                for (int i = 0; i < [list count]; i++) {
                                    // To NSString object.
                                    [storeList addObject:[list[i] stringValue]];
                                }
                                
                                complete(storeList);
                            }
                        }
                        else if (statusCode == 404) {
                            printf("[STORE LIST 🍎] Does not exist on the server.\n");
                            complete(nil);
                        }
                        else if (statusCode == 503) {
                            printf("[STORE LIST 🍎] Service is temporarily unavailable.\n");
                            complete(nil);
                        }
                        else if (statusCode == 504) {
                            printf("[STORE LIST 🍎] Request took too long to send.\n");
                            complete(nil);
                        }
                        else if (statusCode >= 506 && statusCode <= 512) {
                            printf("[STORE LIST 🍎] Service is down.\n");
                            complete(nil);
                        }
                        else if (sessionError) {
                            printf("[STORE LIST 🍎] Session error.\n");
                            complete(nil);
                        } else {
                            printf("[STORE LIST 🍎] Something went wrong.\n");
                            complete(nil);
                        }
                    } else {
                        printf("[STORE LIST 🍎] Invalid response.\n");
                        complete(nil);
                    }
                }] resume];
}

+ (void)requestProductList:(void(^)(NSDictionary *productList))complete {
    
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
