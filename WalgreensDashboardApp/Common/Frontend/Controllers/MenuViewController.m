//
//  TableViewController.m
//  WalgreensDashboardMock
//
//  Created by Sebastian Garbarek on 26/04/17.
//  Copyright © 2017 Sebastian Garbarek. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuItemCell.h"

#import "StoreListController.h"

#import "DatabaseManager.h"
#import "SharedCommands.h"

@interface MenuViewController () {
    WalgreensAPI *walgreensAPI;
    DatabaseManager *databaseManager;
    NSArray *menuItems;
    int numberOfStoresOnline;
}

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuItems = @[@"Stores Online", @"Stores Offline"];
    
    // Create and place the refresh button in the navigaion bar.
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                  target:self
                                                                                  action:@selector(checkServerStatus)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    // Assign this class to be the responder of the Walgreens API delegate methods.
    walgreensAPI = [[WalgreensAPI alloc] init];
    walgreensAPI.delegate = self;
    
    // Initialize database manager for Walgreens API database and get the number of online stores.
    databaseManager = [[DatabaseManager alloc] initWithDatabaseFilename:WalgreensAPIDatabaseFilename];
    numberOfStoresOnline = [self getNumberOfStoresOnlineFromDatabase];
    
    [self checkServerStatus];
}

- (int)getNumberOfStoresOnlineFromDatabase {
    NSMutableArray *result = [databaseManager executeQuery:SC_GetNumberOfOnlineStoresCommand];
    NSDictionary *row = result[0];
    return [[row objectForKey:@"total"] intValue];
}

- (void)checkServerStatus {
    [_photoServerStatus setTextColor:UIColor.blackColor];
    [_photoServerStatus setText:@"Checking..."];
    [_storeServerStatus setTextColor:UIColor.blackColor];
    [_storeServerStatus setText:@"Checking..."];
    
    // Check if the servers are online.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [walgreensAPI checkStatusOfServices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Menu Item" forIndexPath:indexPath];
    
    [[cell menuItemLabel] setText:menuItems[[indexPath row]]];
    
    if ([menuItems[[indexPath row]] isEqualToString:@"Stores Online"]) {
        [[cell secondaryLabel] setText:[NSString stringWithFormat:@"%i", numberOfStoresOnline]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([menuItems[[indexPath row]] isEqualToString:@"Stores Online"]) {
        // Deselect the cell.
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self performSegueWithIdentifier:@"Display Online Stores" sender:self];
    }
}

#pragma mark - Walgreens API -

// Response with data received successfully.
- (void)walgreensAPIDidSendData:(WalgreensAPI *)sender withData:(NSDictionary *)dictionaryData {
    // Turn off the network activity indicator.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // Get the store numbers from the response data to set shared data.
    //[temporaryData setStoreNumbers:[dictionaryData valueForKey:@"store"]];
    
    // Go to store list screen.
    [self performSegueWithIdentifier:@"Display Online Stores" sender:self];
}

- (void)walgreensAPIStatus:(WalgreensAPI *)sender withStatuses:(NSDictionary *)serviceStatuses {
    // Turn off the network activity indicator.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // Display the status of the services.
    NSString *storeStatus = [serviceStatuses valueForKey:@"Store Locator API"];
    NSString *photoStatus = [serviceStatuses valueForKey:@"Photo Print API"];
    
    if ([storeStatus isEqualToString:@"Online"]) {
        [_storeServerStatus setTextColor:UIColor.greenColor];
    } else {
        [_storeServerStatus setTextColor:UIColor.redColor];
    }
    
    if ([photoStatus isEqualToString:@"Online"]) {
        [_photoServerStatus setTextColor:UIColor.greenColor];
    } else {
        [_photoServerStatus setTextColor:UIColor.redColor];
    }
    
    [_storeServerStatus setText:storeStatus];
    [_photoServerStatus setText:photoStatus];
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
    
    // Turn off the network activity indicator.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - Navigation -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Display Store Numbers"]) {

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
