//
//  StoreListController.m
//  WalgreensDashboardMock
//
//  Created by Sebastian Garbarek on 28/04/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "StoreListController.h"
#import "StoreNumberCell.h"
#import "StoreDetailViewController.h"
#import "WalgreensAPI.h"
#import "DatabaseManager.h"
#import "SharedCommands.h"

@interface StoreListController () {
    WalgreensAPI *walgreensAPI;
    DatabaseManager *databaseManager;
    
    NSMutableArray *onlineStores;
    NSMutableArray *storeNumbers;
}

@end

@implementation StoreListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    // Create and place the refresh button in the navigaion bar.
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                  target:self
                                                                                  action:@selector(refreshStoreList)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    self.navigationItem.title = @"Store List";
    */
     
    // Assign this class to be the responder of the Walgreens API delegate methods.
    walgreensAPI = [[WalgreensAPI alloc] init];
    walgreensAPI.delegate = self;
    
    databaseManager = [[DatabaseManager alloc] initWithDatabaseFilename:WalgreensAPIDatabaseFilename];
    [self getOnlineStoresFromDatabase];
    [_numberOfActiveStoresLabel setText:[NSString stringWithFormat:@"%lu Active Store(s):", [onlineStores count]]];
}

- (void)getOnlineStoresFromDatabase {
    onlineStores = [[NSMutableArray alloc] init];
    storeNumbers = [[NSMutableArray alloc] init];
    
    NSArray *result = [databaseManager executeQuery:SC_GetOnlineStoresCommand];
    
    for (int i = 0; i < [result count]; i++) {
        NSDictionary *row = result[i];
        [onlineStores addObject:[NSString stringWithFormat:@"%@, %@", [row objectForKey:@"state"], [row objectForKey:@"street"]]];
        [storeNumbers addObject:[NSString stringWithFormat:@"%@", [row objectForKey:@"storeNum"]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Method called by refresh button.
- (void)refreshStoreList {
    // Start the network activity indicator.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [walgreensAPI requestStoreNumbers];
}

#pragma mark - Table View -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [onlineStores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Store Number Cell" forIndexPath:indexPath];
    
    // Get String value of NSNumber.
    NSString *store = onlineStores[[indexPath row]];

    // Set the label to store number.
    [[cell numberLabel] setText:store];
    
    return cell;
}

#pragma mark - Walgreens API -

// Response with data received successfully.
- (void)walgreensAPIDidSendData:(WalgreensAPI *)sender withData:(NSDictionary *)dictionaryData {
    // Turn off the network activity indicator.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // Get the store numbers from the response data to set shared data.
    //[temporaryData setStoreNumbers:[dictionaryData valueForKey:@"store"]];
    
    // Reload the data in the table view.
    [self.tableView reloadData];
}

// The user is not connected, notify the user by displaying a message on the screen.
- (void)walgreensAPICouldNotConnect:(WalgreensAPI *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You Are Not Connected to the Internet"
                                                                   message:@"This action can't be completed because you are currently offline."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    // Add option to enter device settings.
    [alert addAction:[UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        return;
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    // Turn off the network activity indicator.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

// The server responded with nil data, notify the user that something went wrong and to try again.
- (void)walgreensAPIDidSendNil:(WalgreensAPI *)sender {
    [self displayOKAlertwithTitle:@"Something Went Wrong" withMessage:@"Please try again."];
    
    // Turn off the network activity indicator.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

// The server responded with an error. Depending on the error, display to user what went wrong.
- (void)walgreensAPIDidSendError:(WalgreensAPI *)sender withData:(NSDictionary *)dictionaryData {
    if ([[dictionaryData valueForKey:@"errCode"] intValue] >= 506) {
        // Display alert with message set as error description contained in response.
        [self displayOKAlertwithTitle:@"The Server is Temporarily Unavailable" withMessage:[dictionaryData valueForKey:@"errDesc"]];
    } else if ([[dictionaryData valueForKey:@"errCode"] intValue] == 504) {
        [self displayOKAlertwithTitle:@"Your Request Timed Out" withMessage:@"Please try again."];
    } else {
        [self displayOKAlertwithTitle:@"An Unexpected Error Occured" withMessage:@"Please try again."];
    }
}

#pragma mark - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Show Store Detail"]) {
        StoreDetailViewController *storeDetailViewController = [segue destinationViewController];
        
        NSIndexPath *selectedPath = [[self tableView] indexPathForSelectedRow];
        storeDetailViewController.selectedStoreNumber = storeNumbers[[selectedPath row]];
    }
}

#pragma mark - Helper Methods -

- (void)displayOKAlertwithTitle:(NSString *)title withMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        return;
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
