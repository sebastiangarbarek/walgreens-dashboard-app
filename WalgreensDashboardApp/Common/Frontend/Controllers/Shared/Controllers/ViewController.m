//
//  SharedViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createDatabaseConnection];
}

- (void)createDatabaseConnection {
    self.databaseManager = [[DatabaseManager alloc] init];
    [self.databaseManager openCreateDatabase];
}

- (void)configureViewOnAppearWithThemeColor:(UIColor *)themeColor {
    [self setTextColorTabItem];
    // Different for each screen.
    [self setSelectedTabBackgroundImage:themeColor];
    
    // Set colors of navigation bar.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = themeColor;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)setTextColorTabItem {
    [self.tabBarController.tabBar.selectedItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateFocused];
}

- (void)setSelectedTabBackgroundImage:(UIColor *)themeColor {
    CGSize tabSize = CGSizeMake(self.tabBarController.tabBar.frame.size.width / self.tabBarController.tabBar.items.count, self.tabBarController.tabBar.frame.size.height);
    
    UIGraphicsBeginImageContextWithOptions(tabSize, NO, 0);
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, tabSize.width, tabSize.height)];
    [themeColor setFill];
    [path fill];
    UIImage* selectedBackground = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.tabBarController.tabBar setSelectionIndicatorImage:selectedBackground];
}

@end
