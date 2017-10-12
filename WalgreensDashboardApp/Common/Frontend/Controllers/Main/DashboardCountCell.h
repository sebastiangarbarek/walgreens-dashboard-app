//
//  DashboardCell.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 9/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardCountCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
