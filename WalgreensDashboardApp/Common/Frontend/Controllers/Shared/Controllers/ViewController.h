//
//  SharedViewController.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DatabaseManager.h"

@interface ViewController : UIViewController

@property DatabaseManager *databaseManager;

- (void)configureViewOnAppearWithThemeColor:(UIColor *)themeColor;

@end
