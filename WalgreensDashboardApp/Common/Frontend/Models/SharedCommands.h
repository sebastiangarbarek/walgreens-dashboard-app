//
//  SharedDatabaseCommands.h
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 29/05/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import <Foundation/Foundation.h>

//static const char *const SC_GetNumberOfOnlineStoresCommand = "SELECT COUNT(*) AS total FROM store_detail WHERE status = 'Online' AND photoInd = 'true'";
static const char *const SC_GetNumberOfOnlineStoresCommand = "SELECT COUNT(*) AS total FROM store_detail WHERE photoInd = 'true'";
static const char *const SC_GetNumberOfOfflineStoresCommand = "SELECT COUNT(*) AS total FROM store_detail WHERE status = 'Offline' AND photoInd = 'true'";
static const char *const SC_GetOfflineStoresCommand = "SELECT * FROM store_detail WHERE status = 'Offline' AND photoInd = 'true'";
//static const char *const SC_GetOnlineStoreDetailsCommand = "SELECT * FROM store_detail WHERE status = 'Online' AND photoInd = 'true'";
static const char *const SC_GetOnlineStoreDetailsCommand = "SELECT * FROM store_detail WHERE photoInd = 'true'";
static const char *const SC_GetOnlineStoresCommand = "SELECT storeNum, state, street FROM store_detail WHERE photoInd = 'true'";
static const char *const SC_GetStoreDetailCommand = "SELECT * FROM store_detail WHERE storeNum = %s";
