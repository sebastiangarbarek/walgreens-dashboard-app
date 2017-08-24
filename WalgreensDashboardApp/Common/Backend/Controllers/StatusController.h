//
//  StatusController.h
//  WalgreensAPIHarvester
//
//  Created by Sebastian Garbarek on 23/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Controller.h"

@interface StatusController : Controller <WalgreensAPIDelegate>

- (BOOL)updateStoreStatusesForToday;

@end
