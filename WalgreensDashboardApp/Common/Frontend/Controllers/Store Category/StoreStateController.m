//
//  StoreStateController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 15/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreStateController.h"

@interface StoreStateController () {
    NSArray *sectionTitles;
    NSArray *indexTitles;
    NSMutableDictionary *cellsToSection;
    NSMutableDictionary *cellsToSectionAbbr;
}

@end

@implementation StoreStateController

#pragma mark - Parent Methods –

- (void)awakeFromNib {
    [super awakeFromNib];
    cellsToSection = [NSMutableDictionary new];
    cellsToSectionAbbr = [NSMutableDictionary new];
    [self initData];
    [self.tableView reloadData];
}

#pragma mark - Init Methods -

- (void)initData {
    // Walgreens database only holds state abbreviations. Database query return states in alphabetical order.
    NSArray *stateAbbreviations = [self.databaseManagerApp.selectCommands selectStatesInStoreDetail];
    // Switch abbreviations for full names, array maintains order of elements.
    NSArray *states = [self postalAbbreviationsToName:stateAbbreviations];
    
    /*
     The dictionary will map array of state names to their first letter,
     so for every state, get the first letter and capitalize it,
     retrieve an array from the dictionary using the letter as the key,
     add the state to the array and set the array to the letter key.
     Standard for loop as we are iterating over two arrays,
     this is because we need to keep track of abbreviations, as the
     abbreviations are stored and used in the database for retrieval.
     */
    for (int i = 0; i < [states count]; i++) {
        NSString *state = [states objectAtIndex:i];
        NSString *stateAbbr = [stateAbbreviations objectAtIndex:i];
        
        NSString *letter = [state substringToIndex:1];
        letter = [letter uppercaseString];
        
        NSMutableArray *statesForLetter = [cellsToSection objectForKey:letter];
        NSMutableArray *statesForLetterAbbr = [cellsToSectionAbbr objectForKey:letter];
        
        // If this is the first state for the letter the mapping does not exist yet.
        if (!statesForLetter) {
            statesForLetter = [NSMutableArray new];
            statesForLetterAbbr = [NSMutableArray new];
        }
        
        [statesForLetter addObject:state];
        [statesForLetterAbbr addObject:stateAbbr];
        [cellsToSection setObject:statesForLetter forKey:letter];
        [cellsToSectionAbbr setObject:statesForLetterAbbr forKey:letter];
    }
    
    // Finally set the data for the section titles.
    NSArray *keys = [cellsToSection allKeys];
    sectionTitles = [keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    // Have the index display the entire alphabet.
    // indexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
}

- (NSArray *)postalAbbreviationsToName:(NSArray *)postalAbbreviations {
    NSMutableArray *names = [NSMutableArray new];
    
    typedef void (^CaseBlock)();
    
    // Objective-C cannot perform a switch on NSString... We must improvise.
    NSDictionary *stringSwitchCase = @{
                                       @"AL": ^{[names addObject:@"Alabama"];},
                                       @"AK": ^{[names addObject:@"Alaska"];},
                                       @"AZ": ^{[names addObject:@"Arizona"];},
                                       @"AR": ^{[names addObject:@"Arkansas"];},
                                       @"CA": ^{[names addObject:@"California"];},
                                       @"CO": ^{[names addObject:@"Colorado"];},
                                       @"CT": ^{[names addObject:@"Connecticut"];},
                                       @"DE": ^{[names addObject:@"Delaware"];},
                                       @"FL": ^{[names addObject:@"Florida"];},
                                       @"GA": ^{[names addObject:@"Georgia"];},
                                       @"HI": ^{[names addObject:@"Hawaii"];},
                                       @"ID": ^{[names addObject:@"Idaho"];},
                                       @"IL": ^{[names addObject:@"Illinois"];},
                                       @"IN": ^{[names addObject:@"Indiana"];},
                                       @"IA": ^{[names addObject:@"Iowa"];},
                                       @"KS": ^{[names addObject:@"Kansas"];},
                                       @"KY": ^{[names addObject:@"Kentucky"];},
                                       @"LA": ^{[names addObject:@"Louisiana"];},
                                       @"ME": ^{[names addObject:@"Maine"];},
                                       @"MD": ^{[names addObject:@"Maryland"];},
                                       @"MA": ^{[names addObject:@"Massachusetts"];},
                                       @"MI": ^{[names addObject:@"Michigan"];},
                                       @"MN": ^{[names addObject:@"Minnesota"];},
                                       @"MS": ^{[names addObject:@"Mississippi"];},
                                       @"MO": ^{[names addObject:@"Missouri"];},
                                       @"MT": ^{[names addObject:@"Montana"];},
                                       @"NE": ^{[names addObject:@"Nebraska"];},
                                       @"NV": ^{[names addObject:@"Nevada"];},
                                       @"NH": ^{[names addObject:@"New Hampshire"];},
                                       @"NJ": ^{[names addObject:@"New Jersey"];},
                                       @"NM": ^{[names addObject:@"New Mexico"];},
                                       @"NY": ^{[names addObject:@"New York"];},
                                       @"NC": ^{[names addObject:@"North Carolina"];},
                                       @"ND": ^{[names addObject:@"North Dakota"];},
                                       @"OH": ^{[names addObject:@"Ohio"];},
                                       @"OK": ^{[names addObject:@"Oklahoma"];},
                                       @"OR": ^{[names addObject:@"Oregon"];},
                                       @"PA": ^{[names addObject:@"Pennsylvania"];},
                                       @"RI": ^{[names addObject:@"Rhode Island"];},
                                       @"SC": ^{[names addObject:@"South Carolina"];},
                                       @"SD": ^{[names addObject:@"South Dakota"];},
                                       @"TN": ^{[names addObject:@"Tennessee"];},
                                       @"TX": ^{[names addObject:@"Texas"];},
                                       @"UT": ^{[names addObject:@"Utah"];},
                                       @"VT": ^{[names addObject:@"Vermont"];},
                                       @"VA": ^{[names addObject:@"Virginia"];},
                                       @"WA": ^{[names addObject:@"Washington"];},
                                       @"WV": ^{[names addObject:@"West Virginia"];},
                                       @"WI": ^{[names addObject:@"Wisconsin"];},
                                       @"WY": ^{[names addObject:@"Wyoming"];},
                                       @"PR": ^{[names addObject:@"Puerto Rico"];},
                                       @"VI": ^{[names addObject:@"Virgin Islands"];}};
    // No default...
    
    for (NSString *postalAbbreviation in postalAbbreviations) {
        ((CaseBlock)stringSwitchCase[postalAbbreviation])();
    }
    
    return names;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[cellsToSection objectForKey:sectionTitles[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionTitles objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return sectionTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [sectionTitles indexOfObject:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Store" forIndexPath:indexPath];
    cell.storeName.text = [[cellsToSection objectForKey:sectionTitles[indexPath.section]] objectAtIndex:indexPath.row];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"State Cities"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        StoreCityController *storeCityController = [segue destinationViewController];
        // Retrieve and pass state abbreviation.
        storeCityController.state = [[cellsToSectionAbbr objectForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    }
}

@end
