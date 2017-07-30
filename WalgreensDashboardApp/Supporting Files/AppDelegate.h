//
//  AppDelegate.h
//  WalgreensDashboardMock
//
//  Created by Sebastian Garbarek on 26/04/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StatusController.h"
#import "DatabaseManagerApp.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property StatusController *statusController;
@property DatabaseManagerApp *databaseManagerApp;

@end
