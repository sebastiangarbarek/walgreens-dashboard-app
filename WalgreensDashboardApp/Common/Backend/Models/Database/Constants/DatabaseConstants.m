//
//  DatabaseConstants.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 16/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DatabaseConstants.h"

// Table names.
NSString *const kStoreTableName = @"store_detail";
NSString *const kProductTableName = @"product_detail";
NSString *const kHistoryTableName = @"offline_history";
NSString *const kStoreHourTableName = @"store_hour";

// Store detail.
NSString *const kStoreNum = @"storeNum";
NSString *const kLat = @"latitude";
NSString *const kLong = @"longitude";
NSString *const kAddr = @"street";
NSString *const kCity = @"city";
NSString *const kState = @"state";
NSString *const kDistrict = @"districtNum";
NSString *const kArea = @"storeAreaCd";
NSString *const kTimeZone = @"timezone";
NSString *const kTwentyFourHours = @"twentyFourHr";
NSString *const kPhone = @"storePhoneNum";
NSString *const kMonOpen = @"monOpen";
NSString *const kMonClose = @"monClose";
NSString *const kTueOpen = @"tueOpen";
NSString *const kTueClose = @"tueClose";
NSString *const kWedOpen = @"wedOpen";
NSString *const kWedClose = @"wedClose";
NSString *const kThuOpen = @"thuOpen";
NSString *const kThuClose = @"thuClose";
NSString *const kFriOpen = @"friOpen";
NSString *const kFriClose = @"friClose";
NSString *const kSatOpen = @"satOpen";
NSString *const kSatClose = @"satClose";
NSString *const kSunOpen = @"sunOpen";
NSString *const kSunClose = @"sunClose";
NSString *const kPhotoStatus = @"photoStatusCd";

// Product detail.
NSString *const kProId = @"productId";
NSString *const kProGroup = @"productGroupId";
NSString *const kProSize = @"productSize";
NSString *const kProPrice = @"productPrice";

// Offline history.
NSString *const kOfflineDateTime = @"offlineDateTime";
NSString *const kOnlineDateTime = @"onlineDateTime";
