//
//  OfflineStoreCell.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 30/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfflineStoreCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *storeDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *offlineTimeLabel;

@end
