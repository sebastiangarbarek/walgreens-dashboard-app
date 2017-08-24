//
//  DataController.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 23/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "Controller.h"

@interface DataController : Controller <WalgreensAPIDelegate>

- (void)requestAndInsertAllStoreData;
- (NSArray *)isStoreDataIncomplete;
- (void)requestAndInsertAllStoreDataWithList:(NSArray *)storeList;
- (void)requestAndInsertAllProductData;

@end
