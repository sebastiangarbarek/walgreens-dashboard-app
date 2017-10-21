//
//  StoreStateController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 15/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreStateController.h"

@interface StoreStateController () {
    NSArray *indexTitles;
    int numberOfResults;
}

@end

@implementation StoreStateController

#pragma mark - Parent Methods –

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [self initData];
}

#pragma mark - Init Methods -

- (void)initData {
    self.cellsToSection = [NSMutableDictionary new];
    self.cellsToSectionAbbr = [NSMutableDictionary new];
    
    if (self.stores) {
        [self initUsingCustomStoreSet];
    } else {
        [self initUsingAllPrintStores];
    }
    
    // Finally set the data for the section titles.
    NSArray *keys = [self.cellsToSection allKeys];
    self.sectionTitles = [keys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    // (Optional) Have the index display the entire alphabet.
    // indexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
}

- (void)initUsingAllPrintStores {
    // Walgreens database only holds state abbreviations. Database query return states in alphabetical order.
    NSArray *stateAbbreviations = [self.databaseManager.selectCommands selectStatesInStoreDetail];
    // Switch abbreviations for full names, array maintains order of elements.
    NSArray *states = [self postalAbbreviationsToName:stateAbbreviations];
    
    [self mapStates:states abbreviations:stateAbbreviations];
}

// Takes an array of states (full name) and an array of abbreviations from the data set.
- (void)mapStates:(NSArray *)states abbreviations:(NSArray *)stateAbbreviations {
    numberOfResults = [states count];
    
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
        
        NSMutableArray *statesForLetter = [self.cellsToSection objectForKey:letter];
        NSMutableArray *statesForLetterAbbr = [self.cellsToSectionAbbr objectForKey:letter];
        
        // If this is the first state for the letter the mapping does not exist yet.
        if (!statesForLetter) {
            statesForLetter = [NSMutableArray new];
            statesForLetterAbbr = [NSMutableArray new];
        }
        
        [statesForLetter addObject:state];
        [statesForLetterAbbr addObject:stateAbbr];
        
        // Set the data to display.
        [self.cellsToSection setObject:statesForLetter forKey:letter];
        [self.cellsToSectionAbbr setObject:statesForLetterAbbr forKey:letter];
    }
}

#pragma mark - Custom Set Init Methods -

- (void)initUsingCustomStoreSet {
    NSArray *stateAbbreviations = [self statesFrom:self.stores];
    NSArray *states = [self postalAbbreviationsToName:stateAbbreviations];
    
    [self mapStates:states abbreviations:stateAbbreviations];
}

// Returns an array of state string abbreviations.
- (NSArray *)statesFrom:(NSArray *)storeSet {
    // Set data structure to rid duplicates.
    NSMutableOrderedSet *states = [NSMutableOrderedSet new];
    for (NSDictionary *store in storeSet) {
        [states addObject:[store objectForKey:kState]];
    }
    return [states array];
}

#pragma mark - Helper Methods -

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

#pragma mark - Table View Methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.cellsToSection objectForKey:self.sectionTitles[section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionTitles objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.sectionTitles indexOfObject:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BasicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Store" forIndexPath:indexPath];
    cell.label.text = [[self.cellsToSection objectForKey:self.sectionTitles[indexPath.section]] objectAtIndex:indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == ([self.sectionTitles count] - 1)) {
        return [NSString stringWithFormat:@"%i result(s)", numberOfResults];
    }
    return @"";
}

#pragma mark - Navigation Methods -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     Could skip delegation and use parentViewController,
     however a child view controller shouldn't be responsible for a transition.
     */
    [self.segueDelegate child:self willPerformSegueWithIdentifier:@"State Cities"];
}

- (NSArray *)storesInState:(NSString *)selectedState {
    NSMutableArray *storesInState = [NSMutableArray new];
    for (NSDictionary *store in self.stores) {
        if ([[store objectForKey:kState] isEqualToString:selectedState]) {
            [storesInState addObject:store];
        }
    }
    return storesInState;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Only use this segue if stores are custom set.
    if (self.stores) {
        if ([[segue identifier] isEqualToString:@"State Cities - Custom"]) {
            NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;

            // Pass state information.
            NSString *selectedState = [[self.cellsToSectionAbbr
                                          objectForKey:[self.sectionTitles objectAtIndex:indexPath.section]]
                                         objectAtIndex:indexPath.row];
            
            // Pass the custom set of stores.
            StoreCityController *storeCityController = [segue destinationViewController];
            // Only pass stores for the selected state to save memory.
            storeCityController.stores = [self storesInState:selectedState];
            
            storeCityController.navigationTitle =
            [[self.cellsToSection objectForKey:[self.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        }
    }
}

@end
