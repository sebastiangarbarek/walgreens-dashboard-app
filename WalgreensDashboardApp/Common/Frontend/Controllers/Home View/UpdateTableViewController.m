//
//  HomeViewController.m
//  WalgreensDashboardApp
//
//  Created by Sebastian Garbarek on 29/07/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "UpdateTableViewController.h"
#import "HomeViewController.h"
#import "DatabaseManagerApp.h"

@interface UpdateTableViewController () {
    DatabaseManagerApp *databaseManagerApp;
}

@end

@implementation UpdateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Retrieve selected date from home view controller.
    self.date = ((HomeViewController *)self.parentViewController).date;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeOnlineUpdate)
                                                 name:@"Store online"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeOfflineUpdate)
                                                 name:@"Store offline"
                                               object:nil];
    // View should update accordingly.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestsCompleteUpdate)
                                                 name:@"Requests complete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeOpenUpdate)
                                                 name:@"Store Open"
                                               object:nil];
    
    databaseManagerApp = [[DatabaseManagerApp alloc] init];
    [databaseManagerApp openCreateDatabase];
    
    [self reloadData];
}

- (void)reloadData {
    self.totalOnlineStoresLabel.text = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands countOnlineStoresInTempTable] intValue]];
    self.totalOfflineStoresLabel.text = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:[DateHelper currentDate]] intValue]];
    self.totalOpenStoresLabel.text = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands selectTwentyFourHourStores] intValue]];
}

- (void)storeOnlineUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTotalStoresOnline];
    });
}

- (void)storeOfflineUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTotalStoresOffline];
    });
}


-(void)storeOpenUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateTotalStoresOpen];
    });
}
//
//- (void)storeCloseUpdate {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self updateTotaleStoresClosed];
//    });
//}
//

- (void)updateTotalStoresOnline {
    self.totalOnlineStoresLabel.text = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands countOnlineStoresInTempTable] intValue]];
}

- (void)updateTotalStoresOffline {
    self.totalOfflineStoresLabel.text = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands countOfflineInHistoryTableWithDate:[DateHelper currentDate]] intValue]];
}

-(void)updateTotalStoresOpen {
    self.totalOpenStoresLabel.text = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands selectTwentyFourHourStores] intValue]];
}
//
//-(void)updateTotalStoresClosed {
//    self.totalClosedStoresLabel.text = [NSString stringWithFormat:@"%i", [[databaseManagerApp.selectCommands selectOnlineStoreIdsInStoreTable]]]
//}


- (void)requestsCompleteUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Update view accordingly.
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        // Store status section
        case 0: {
            switch (indexPath.row) {
                // Online row
                case 0: {
                    break;
                }
                // Offline row
                case 1: {
                    // Get home view.
                    HomeViewController *homeViewController = (HomeViewController *)self.parentViewController;
                    
                    // Swap container view.
                    UIStoryboard *offlineStoryBoard = [UIStoryboard storyboardWithName:@"OfflineView" bundle:nil];
                    UITableViewController *offlineTableViewController = [offlineStoryBoard instantiateViewControllerWithIdentifier:@"Offline Table View"];
                    [homeViewController animateTransitionTo:offlineTableViewController transition:Push];
                    
                    [homeViewController switchBackButton];
                    
                    break;
                }
            }
            break;
        }
        // Store hours section
        case 1: {
            switch (indexPath.row){
                // Open row
                case 0: {
                    break;
                }
                
                // Close row
                case 1: {
                    break;
                }
                    
            }
            
            break;
        }
    }
    // Push selected view onto navigation stack.
}
//
//-(NSString *)getLocalTime{
//    
//    NSDate *localTime = [NSDate date];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss cc"];
//    
////    NSString *dateString = [dateFormatter stringFromDate:localTime];
//    
//    NSTimeZone *localTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"NZDT"];
////    NSDate changeStrToDate = [dateFormatter dateFromString:databaseManagerApp.]
////    NSTimeZone *destinationTimeZone = [NSTimeZone ]
//    
//    
//    }
//
//-(NSString *)changeStoreTimeToUTC{
//    
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//    [dateFormatter setDateFormat:@"HH:mm:ss"];
//    
//    NSMutableArray *tmp = [databaseManagerApp.selectCommands.selectMondayOpeningHours[@"storeNum"] mutableCopy];
//
//  
//}
//


@end
