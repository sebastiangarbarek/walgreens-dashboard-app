//
//  TableViewController.h
//  WalgreensDashboardMock
//
//  Created by Sebastian Garbarek on 26/04/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WalgreensAPI.h"

@interface MenuViewController : UIViewController <WalgreensAPIDelegate>

@property (weak, nonatomic) IBOutlet UILabel *storeServerStatus;
@property (weak, nonatomic) IBOutlet UILabel *photoServerStatus;
@property (weak, nonatomic) IBOutlet UILabel *numberOfOnlineStores;
@property (weak, nonatomic) IBOutlet UILabel *numberOfOfflineStores;
- (IBAction)nextDayButton:(id)sender;
- (IBAction)lastDayButton:(id)sender;

@end
