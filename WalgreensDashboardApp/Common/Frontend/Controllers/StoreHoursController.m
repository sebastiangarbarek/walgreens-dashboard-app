//
//  StoreHoursController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 1/10/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreHoursController.h"

@interface StoreHoursController () {
    NSString *notification;
    NSString *date;
    BOOL timesCalculated;
    NSMutableArray *openStores;
    NSMutableArray *closedStores;
}

@end

@implementation StoreHoursController

#pragma mark - Parent Methods -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInitialData];
}

- (void)viewDidAppear:(BOOL)animated {
    static dispatch_once_t onceToken;
    // Dispatch once is synchronous.
    dispatch_once (&onceToken, ^{
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
    notification = @"Checking Store Times";
    date = @"Today";
    timesCalculated = NO;
}

- (void)updateStores {
    [self updateStoresWithDateTime:self.dateTime];
}

- (void)updateStoresWithDateTime:(NSString *)dateTime {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        if (self.storeTimes == nil) {
            self.storeTimes = [[StoreTimes alloc] init];
        }
        
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
            [self.tableView beginUpdates];
            // Prevent reloading the entire table view if other data exists.
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0], nil]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:4 inSection:0], nil]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            
            [self startStoreTimerWithSeconds:[self.storeTimes secondsToNextHour]];
        });
    });
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            SingleLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Notification" forIndexPath:indexPath];
            cell.label.text = notification;
            return cell;
        }
        case 1: {
            SingleLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Date" forIndexPath:indexPath];
            cell.label.text = date;
            return cell;
        }
        case 2: {
            StoreTimesMapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Map" forIndexPath:indexPath];
            if (timesCalculated) {
                cell.segueDelegate = self;
                [cell loadWithStores:openStores];
            } else {
                [cell loadWithoutStores];
            }
            return cell;
        }
        case 3: {
            DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Open" forIndexPath:indexPath];
            if (timesCalculated) {
                cell.detail.text = [NSString stringWithFormat:@"%li", [openStores count]];
            }
            return cell;
        }
        case 4: {
            DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Closed" forIndexPath:indexPath];
            if (timesCalculated) {
                cell.detail.text = [NSString stringWithFormat:@"%li", [closedStores count]];
            }
            return cell;
        }
        default:
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            if (timesCalculated) {
                return 0;
            } else {
                return 22;
            }
        case 1:
            return 22;
        case 2:
            return 264;
        case 3:
            return 44;
        case 4:
            return 44;
        default:
            break;
    }
    
    return 0;
}

#pragma mark - Navigation Methods -

- (void)child:(id)child willPerformSegueWithIdentifier:(NSString *)segueIdentifier {
    [self performSegueWithIdentifier:segueIdentifier sender:child];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Store Details"]) {
        StoreTimesMapCell *storeTimesMapCell = (StoreTimesMapCell *)sender;
        StoreDetailsController *storeDetailsController = [segue destinationViewController];
        storeDetailsController.storeNumber = storeTimesMapCell.storeNumber;
    }
}

@end
