//
//  StoreListController.h
//  WalgreensDashboardMock
//
//  Created by Sebastian Garbarek on 28/04/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WalgreensAPI.h"

@interface StoreListController : UITableViewController <WalgreensAPIDelegate>

@property (weak, nonatomic) IBOutlet UILabel *numberOfActiveStoresLabel;

@end
