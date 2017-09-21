//
//  DashboardController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 4/09/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "DashboardController.h"

@interface DashboardController () {
    NSArray *sectionTitles;
    NSMutableDictionary *cellsToSection;
    BOOL requestsComplete;
}

@end

@implementation DashboardController

#pragma mark - Parent Methods -

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addNotifications];
    // Use one instance.
    self.storeTimes = [[StoreTimes alloc] init];
    cellsToSection = [NSMutableDictionary new];
}

- (void)viewDidAppear:(BOOL)animated {
    [self initData];
}

#pragma mark - Init Methods -

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateProgressView)
                                                 name:@"Store online"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateStoresOffline)
                                                 name:@"Store offline"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestsCompleteUpdate)
                                                 name:@"Requests complete"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notConnectedUpdate)
                                                 name:@"Not connected"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectedUpdate)
                                                 name:@"Connected"
                                               object:nil];
}

- (void)initData {
    [self updateProgressView];
    
    sectionTitles = @[@"Today's Offline Stores", @"Stores Currently Open"];
    
    [self loadOfflineStores];
    
    NSArray *mapCells = @[@1];
    [cellsToSection setValue:mapCells forKey:sectionTitles[1]]; // One map cell.
    
    [self.tableView reloadData];
}

- (void)loadOfflineStores {
    NSMutableArray *offlineStores = [self.databaseManagerApp.selectCommands selectOfflineStoresInHistoryTableWithDate:[DateHelper currentDate]];
    [offlineStores insertObject:[NSNumber numberWithInt:1] atIndex:0]; // Reserve first cell as message cell.
    [cellsToSection setValue:offlineStores forKey:sectionTitles[0]];
}

- (void)insertOfflineStore {
    // Add row to end of section.
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[cellsToSection objectForKey:[sectionTitles objectAtIndex:0]] count] - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Update Methods -

- (void)updateProgressView {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger storesInTemp = [[self.databaseManagerApp.selectCommands countStoresInTempTable] integerValue];
        NSInteger storesToRequest = [[self.databaseManagerApp.selectCommands countPrintStoresInStoreTable] integerValue];
        self.progressView.progress = (float)storesInTemp / storesToRequest;
    });
}

- (void)updateStoresOffline {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateProgressView];
        [self loadOfflineStores];
        [self insertOfflineStore];
    });
}

- (void)requestsCompleteUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        requestsComplete = YES;
        [self.progressView setHidden:YES];
        [self initData];
    });
}

- (void)notConnectedUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    });
}

- (void)connectedUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    });
}

#pragma mark - Table View Methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *cells = [cellsToSection objectForKey:sectionTitles[section]];
    if (!cells) {
        return 0;
    } else {
        return [cells count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    /*
     Code smells. Use of switch case can always be replaced with something better...
     Better to move all this code into the respective cell class and call upon it passing the cellsToSection and indexPath.
     Code is repeated and tedious to work with this way.
     */
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Message" forIndexPath:indexPath];
                if ([[cellsToSection objectForKey:sectionTitles[indexPath.section]] count] == 1 && requestsComplete) {
                    ((MessageCell *)cell).message.text = @"No stores found offline today.";
                } else if ([[cellsToSection objectForKey:sectionTitles[indexPath.section]] count] == 1 && !requestsComplete) {
                    ((MessageCell *)cell).message.text = @"No stores found offline yet.";
                } else {
                    ((MessageCell *)cell).message.text = @""; // Cell will be hidden.
                }
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:@"Store" forIndexPath:indexPath];
                
                NSString *storeNum = [[[cellsToSection objectForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"storeNum"];
                NSString *city = [[[cellsToSection objectForKey:[sectionTitles  objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"city"];
                NSString *state = [[[cellsToSection objectForKey:[sectionTitles  objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] objectForKey:@"state"];
                
                if ([city length] != 0) {
                    city = [city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    ((StoreCell *)cell).storeName.text = [NSString stringWithFormat:@"%@, %@", city, state];
                } else {
                    ((StoreCell *)cell).storeName.text = [NSString stringWithFormat:@"Store #%@", storeNum];
                    ((StoreCell *)cell).userInteractionEnabled = NO;
                    ((StoreCell *)cell).accessoryType = UITableViewCellAccessoryNone;
                }
            }
            break;
        }
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Map" forIndexPath:indexPath];
            // Pass open stores and segue delegate.
            ((StoreTimesMapCell *)cell).openStores = [self.storeTimes retrieveStoresWithDateTime:[DateHelper currentDateAndTime] requestOpen:YES];
            ((StoreTimesMapCell *)cell).segueDelegate = self;
            [((StoreTimesMapCell *)cell) initData];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0 && [[cellsToSection objectForKey:sectionTitles[indexPath.section]] count] > 1) {
            // Hide message cell as there are offline stores for today.
            return 0;
        }
    } else if (indexPath.section == 1) {
        return 264;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - Navigation Methods -

- (void)child:(id)child willPerformSegueWithIdentifier:(NSString *)segueIdentifier {
    [self performSegueWithIdentifier:segueIdentifier sender:child];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Store Details"]) {
        StoreDetailsController *storeDetailsController = [segue destinationViewController];
        storeDetailsController.storeNumber = ((StoreTimesMapCell *)sender).storeNumber;
    }
}

@end
