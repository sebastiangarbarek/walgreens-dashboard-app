//
//  DashboardController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "TableViewController.h"
#import "StoreCell.h"
#import "MessageCell.h"
#import "StoreTimesMapCell.h"
#import "StoreDetailsController.h"
#import "SegueProtocol.h"

@interface DashboardController : TableViewController <SegueProtocol>

@property StoreTimes *storeTimes;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
