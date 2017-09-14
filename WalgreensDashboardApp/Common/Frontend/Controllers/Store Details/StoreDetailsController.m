//
//  StoreDetailsController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreDetailsController.h"

/*
 Error prone keys.
 */
static NSString *const kStoreNum = @"storeNum";
static NSString *const kLat = @"latitude";
static NSString *const kLong = @"longitude";
static NSString *const kAddr = @"street";
static NSString *const kCity = @"city";
static NSString *const kState = @"state";
static NSString *const kDistrict = @"districtNum";
static NSString *const kArea = @"storeAreaCd";
static NSString *const kTimeZone = @"timezone";
static NSString *const kHours = @"twentyFourHr";
static NSString *const kPhone = @"storePhoneNum";
static NSString *const kMonOpen = @"monOpen";
static NSString *const kMonClose = @"monClose";
static NSString *const kTueOpen = @"tueOpen";
static NSString *const kTueClose = @"tueClose";
static NSString *const kWedOpen = @"wedOpen";
static NSString *const kWedClose = @"wedClose";
static NSString *const kThuOpen = @"thuOpen";
static NSString *const kThuClose = @"thuClose";
static NSString *const kFriOpen = @"friOpen";
static NSString *const kFriClose = @"friClose";
static NSString *const kSatOpen = @"satOpen";
static NSString *const kSatClose = @"satClose";
static NSString *const kSunOpen = @"sunOpen";
static NSString *const kSunClose = @"sunClose";

@interface StoreDetailsController () {
    NSArray *sectionTitles;
    NSDictionary *cellTitles;
    NSDictionary * storeData;
    NSArray *storeHours;
}

@end

@implementation StoreDetailsController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidAppear:(BOOL)animated {
    [self initData];
    [self.tableView reloadData];
}

#pragma mark - Init Methods -

- (void)initData {
    NSDictionary *storeDictionary;
    NSArray *storeDetailsResultsArray = [self.databaseManagerApp.selectCommands selectStoreDetailsWithStoreNumber:self.storeNumber];

    if (storeDetailsResultsArray && storeDetailsResultsArray.count) {
        storeDictionary = storeDetailsResultsArray[0];
        
        NSArray *storeCoordinates = @[[storeDictionary objectForKey:kLat],
                                      [storeDictionary objectForKey:kLong]];
        
        NSArray *storeDetails = @[[storeDictionary objectForKey:kStoreNum],
                                  [storeDictionary objectForKey:kAddr],
                                  [storeDictionary objectForKey:kCity],
                                  [storeDictionary objectForKey:kState],
                                  [storeDictionary objectForKey:kDistrict],
                                  [storeDictionary objectForKey:kArea],
                                  [storeDictionary objectForKey:kTimeZone],
                                  [storeDictionary objectForKey:kHours],
                                  [storeDictionary objectForKey:kPhone]];
        
        NSArray *storeCells = @[@"Store Number",
                                @"Street",
                                @"City",
                                @"State",
                                @"District Number",
                                @"Area Code",
                                @"Timezone",
                                @"24/7",
                                @"Phone"];
        
        NSDictionary *hoursDictionary;
        NSArray *storeHoursResultsArray = [self.databaseManagerApp.selectCommands selectStoreHoursWithStoreNumber:self.storeNumber];
        if (storeHoursResultsArray && storeHoursResultsArray.count) {
            hoursDictionary = storeHoursResultsArray[0];
            storeHours = @[[NSString stringWithFormat:@"%@ - %@", [hoursDictionary objectForKey:kMonOpen], [hoursDictionary objectForKey:kMonClose]],
                           [NSString stringWithFormat:@"%@ - %@", [hoursDictionary objectForKey:kTueOpen], [hoursDictionary objectForKey:kTueClose]],
                           [NSString stringWithFormat:@"%@ - %@", [hoursDictionary objectForKey:kWedOpen], [hoursDictionary objectForKey:kWedClose]],
                           [NSString stringWithFormat:@"%@ - %@", [hoursDictionary objectForKey:kThuOpen], [hoursDictionary objectForKey:kThuClose]],
                           [NSString stringWithFormat:@"%@ - %@", [hoursDictionary objectForKey:kFriOpen], [hoursDictionary objectForKey:kFriClose]],
                           [NSString stringWithFormat:@"%@ - %@", [hoursDictionary objectForKey:kSatOpen], [hoursDictionary objectForKey:kSatClose]],
                           [NSString stringWithFormat:@"%@ - %@", [hoursDictionary objectForKey:kSunOpen], [hoursDictionary objectForKey:kSunClose]]];
            
            NSArray *hoursCells = @[@"Monday",
                                    @"Tuesday",
                                    @"Wednesday",
                                    @"Thursday",
                                    @"Friday",
                                    @"Saturday",
                                    @"Sunday"];
            
            sectionTitles = @[@"Location",
                              @"Details",
                              @"Hours"];
            
            cellTitles = @{sectionTitles[0] : [NSNull null],
                           sectionTitles[1] : storeCells,
                           sectionTitles[2] : hoursCells};
            
            storeData = @{sectionTitles[0] : storeCoordinates,
                          sectionTitles[1] : storeDetails,
                          sectionTitles[2] : storeHours};
        } else {
            sectionTitles = @[@"Location",
                              @"Details"];
            
            cellTitles = @{sectionTitles[0] : [NSNull null],
                           sectionTitles[1] : storeCells};
            
            storeData = @{sectionTitles[0] : storeCoordinates,
                          sectionTitles[1] : storeDetails};
        }
    }
}

#pragma mark - Table Methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!storeHours || !storeHours.count)
        return [sectionTitles count];
    else
        // Store hours are not available.
        return [sectionTitles count] - 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Exclusive case for map section.
    if (section == 0)
        return 1;
    else
        return [[storeData objectForKey:sectionTitles[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return sectionTitles[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Exclusive case for map section.
    if (indexPath.section == 0) {
        // If coordinates are nil, hide map view.
        if ([storeData objectForKey:sectionTitles[indexPath.section]][0] == nil
            || [storeData objectForKey:sectionTitles[indexPath.section]][1] == nil)
            return 0;
        else {
            return 264;
        }
    } else if ([storeData objectForKey:sectionTitles[indexPath.section]][indexPath.row] == nil) {
        return 0;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *mapIdentifier = @"Map";
    NSString *detailIdentifier = @"Detail";
    
    if (indexPath.section == 0) {
        MapCell *cell = [tableView dequeueReusableCellWithIdentifier:mapIdentifier];
        [cell placeStoreOnMapWithLatitude:[storeData objectForKey:sectionTitles[indexPath.section]][1]
                                longitude:[storeData objectForKey:sectionTitles[indexPath.section]][0]];
        return cell;
    } else {
        DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIdentifier];
        cell.title.text = [cellTitles objectForKey:sectionTitles[indexPath.section]][indexPath.row];
        
        if ([[storeData objectForKey:sectionTitles[indexPath.section]][indexPath.row] isKindOfClass:[NSNumber class]]) {
            cell.detail.text = [[storeData objectForKey:sectionTitles[indexPath.section]][indexPath.row] stringValue];
        } else {
            cell.detail.text = [storeData objectForKey:sectionTitles[indexPath.section]][indexPath.row];
        }
        
        return cell;
    }
    
    return nil;
}

@end
