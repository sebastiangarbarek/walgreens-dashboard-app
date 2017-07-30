//
//  UpdateCell.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 30/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIProgressView *requestProgressView;
@property (weak, nonatomic) IBOutlet UILabel *percentCompleteLabel;

@end
