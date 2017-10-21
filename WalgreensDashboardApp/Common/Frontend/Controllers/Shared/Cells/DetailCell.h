//
//  DetailCell.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end
