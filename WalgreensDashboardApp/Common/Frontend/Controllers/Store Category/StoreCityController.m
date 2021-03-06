//
//  StoreCityController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 15/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreCityController.h"

@interface StoreCityController () {
    NSArray *sectionTitles;
    NSMutableDictionary *cellsToSection;
    int numberOfResults;
}

@end

@implementation StoreCityController

#pragma mark - Parent Methods –

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewWillAppear:(BOOL)animated {
    [self initData];
    [self.tableView reloadData];
}

#pragma mark - Init Methods -

- (void)initData {
    cellsToSection = [NSMutableDictionary new];
    
    if (self.stores) {
        [self initUsingCustomStoreSet];
    } else {
        [self initUsingAllPrintStores];
    }
    
    // Finally set the data for the section titles.
    NSArray *keys = [cellsToSection allKeys];
    sectionTitles = [keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    self.navigationItem.title = self.navigationTitle;
}

- (void)initUsingAllPrintStores {
    NSArray *stores = [self.databaseManager.selectCommands selectStoresInState:self.state];
    [self mapStateStoresToCities:stores];
}

- (void)mapStateStoresToCities:(NSArray *)stores {
    numberOfResults = [stores count];
    
    for (NSDictionary *storeDictionary in stores) {
        NSMutableArray *storesForCity = [cellsToSection objectForKey:[storeDictionary objectForKey:kCity]];
        
        // If this is the first store for the city the mapping does not exist yet.
        if (!storesForCity) {
            storesForCity = [NSMutableArray new];
        }
        
        Store *store = [[Store alloc] init];
        store.storeNumber = [storeDictionary objectForKey:kStoreNum];
        store.descriptor = [storeDictionary objectForKey:kAddr];
        [storesForCity addObject:store];
        
        [cellsToSection setObject:storesForCity forKey:[storeDictionary objectForKey:kCity]];
    }
}

#pragma mark - Custom Set Init Methods -

- (void)initUsingCustomStoreSet {
    [self mapStateStoresToCities:self.stores];
}

#pragma mark - Table View Methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[cellsToSection objectForKey:sectionTitles[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // Walgreens API has a single space in front of every city...
    return [[sectionTitles objectAtIndex:section] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    // Use a set to avoid repeating letters.
    NSMutableSet *indexTitles = [NSMutableSet new];

    for (NSString *sectionTitle in sectionTitles) {
        // Have to declare a new variable due to ARC.
        NSString *sectionTitleNoWhiteSpace = [sectionTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [indexTitles addObject:[sectionTitleNoWhiteSpace substringToIndex:1]];
    }
    
    // Return sorted array.
    return [[indexTitles allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    for (int i = 0; i < [sectionTitles count]; i++) {
        NSString *sectionTitle = sectionTitles[i];
        sectionTitle = [sectionTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([[sectionTitle substringToIndex:1] isEqualToString:title])
            return i;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BasicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Store" forIndexPath:indexPath];
    
    // See initData and Store object for understanding.
    NSString *street = [[[cellsToSection objectForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] descriptor];
    
    if ([street length] != 0) {
        street = [street stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // Fix casing.
        street = [street lowercaseString];
        street = [street capitalizedString];
        cell.label.text = [NSString stringWithFormat:@"%@", street];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == ([sectionTitles count] - 1)) {
        return [NSString stringWithFormat:@"%i result(s)", numberOfResults];
    }
    return @"";
}

#pragma mark - Navigation Methods -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Store Details"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        StoreDetailsController *storeDetailsController = [segue destinationViewController];
        storeDetailsController.storeNumber = [[[cellsToSection objectForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] storeNumber];
    }
}

@end
