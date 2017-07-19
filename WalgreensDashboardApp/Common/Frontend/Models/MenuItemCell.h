//
//  TableViewCell.h
//  WalgreensDashboardMock
//
//  Created by Sebastian Garbarek on 26/04/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *menuItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;

@end
