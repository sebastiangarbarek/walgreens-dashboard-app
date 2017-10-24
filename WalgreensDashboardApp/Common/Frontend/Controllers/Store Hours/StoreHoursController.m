//
//  StoreHoursController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 1/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreHoursController.h"

@interface StoreHoursController () {
    BOOL timesCalculated;
    NSMutableArray *openStores;
    NSMutableArray *closedStores;
    NSInteger selectedSegment;
}

@end

@implementation StoreHoursController

#pragma mark - Parent Methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInitialData];
}

- (void)viewDidAppear:(BOOL)animated {
    [self configureViewOnAppearWithThemeColor:[UIColor printicularYellow]];
    
    static dispatch_once_t onceToken;
    // Dispatch once is synchronous.
    dispatch_once (&onceToken, ^{
        // Storing and using date time as param so custom date time can be used in the future.
        self.dateTime = [DateHelper currentDateAndTime];
        // Once the view has appeared, then calculate store times.
        [self updateStoresWithDateTime:self.dateTime];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    for (int i = 0; i < 3; i++)
        NSLog(@"[WARNING] Store hours controller received memory warning.");
}

#pragma mark - Data Methods -

- (void)loadInitialData {
    self.storeTimes = [[StoreTimes alloc] init];
    openStores = [NSMutableArray new];
    closedStores = [NSMutableArray new];
    timesCalculated = NO;
}

// Wrapper for timer selector.
- (void)updateStores {
    // Storing and using date time as param so custom date time can be used in the future.
    self.dateTime = [DateHelper currentDateAndTime];
    [self updateStoresWithDateTime:self.dateTime];
}

- (void)updateStoresWithDateTime:(NSString *)dateTime {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        [self.storeTimes loadStores];
        
        // Perform algorithm in background thread to prevent blocking.
        NSArray *stores = [self.storeTimes retrieveStoresWithDateTime:[DateHelper currentDateAndTime]];
        // Extract open and closed stores into their own arrays.
        openStores = [NSMutableArray new];
        closedStores = [NSMutableArray new];
        for (NSDictionary *store in stores) {
            if ([[store objectForKey:kOpen] intValue] == 1) {
                [openStores addObject:store];
            } else {
                [closedStores addObject:store];
            }
        }
        timesCalculated = YES;
        
        // Update view in main thread.
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self reloadTimes];
        });
    });
}

- (void)reloadTimes {
    [self.tableView beginUpdates];
    // Prevent reloading the entire table view if other data exists.
    // Notification.
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil]
                          withRowAnimation:UITableViewRowAnimationFade];
    // Map.
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil]
                          withRowAnimation:UITableViewRowAnimationFade];
    // Summary.
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self startStoreTimerWithSeconds:[self.storeTimes secondsToNextHour]];
}

- (void)startStoreTimerWithSeconds:(float)seconds {
    // Keep reference to manually invalidate to allow view to dealloc.
    self.storeTimer = [NSTimer scheduledTimerWithTimeInterval:seconds
                                                       target:self
                                                     selector:@selector(updateStores)
                                                     userInfo:nil
                                                      repeats:NO]; // Yes, it repeats. See selector.
}

#pragma mark - Table View Methods -

// Statically treated.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            return [tableView dequeueReusableCellWithIdentifier:@"Notification"];
        }
        case 1: {
            return [tableView dequeueReusableCellWithIdentifier:@"Filter"];
        }
        case 2: {
            StoreTimesMapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Map" forIndexPath:indexPath];
            if (timesCalculated) {
                cell.segueDelegate = self;
                [cell loadWithStores:openStores selectedStoreHourType:selectedSegment];
            } else {
                [cell loadWithoutStores];
            }
            return cell;
        }
        case 3: {
            OpenClosedCell *openClosedCell = [tableView dequeueReusableCellWithIdentifier:@"Open Closed" forIndexPath:indexPath];
            [openClosedCell loadWithStores:@([openStores count]) closed:@([closedStores count])];
            return openClosedCell;
        }
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            // Notification.
            if (timesCalculated) {
                return 0;
            } else {
                return 22;
            }
        }
        case 1: {
            // Filter.
            return 30;
        }
        case 2: {
            // Map.
            return 264;
        }
        case 3: {
            // Summary.
            CGRect screen = [[UIScreen mainScreen] bounds];
            return screen.size.width;
        }
        default:
            break;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation Methods -

- (IBAction)storeHourTypeChanged:(UISegmentedControl *)sender {
    selectedSegment = [sender selectedSegmentIndex];
    [self reloadTimes];
}

- (void)child:(id)child willPerformSegueWithIdentifier:(NSString *)segueIdentifier {
    [self performSegueWithIdentifier:segueIdentifier sender:child];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Store Details"]) {
        StoreTimesMapCell *storeTimesMapCell = (StoreTimesMapCell *)sender;
        StoreDetailsController *storeDetailsController = [segue destinationViewController];
        storeDetailsController.storeNumber = storeTimesMapCell.storeNumber;
    } else if ([[segue identifier] isEqualToString:@"States (Open)"]) {
        StoreStateController *storeStateController = [segue destinationViewController];
        storeStateController.stores = openStores;
    } else if ([[segue identifier] isEqualToString:@"States (Closed)"]) {
        StoreStateController *storeStateController = [segue destinationViewController];
        storeStateController.stores = closedStores;
    }
}

@end
